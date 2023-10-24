const crypto = require("crypto");
const AWS = require("aws-sdk");
const axios = require("axios");

exports.handler = async (event) => {
    
    // obtencao de URLs do api gateway e cognito
    const apiGatewayUrl = process.env.API_GATEWAY_URL;
    const cognitoTokenUrl = `${process.env.API_COGNITO_URL}oauth2/token`;

    // obtencao de payload
    const requestBody = JSON.parse(event.body);
    const client_id = requestBody.client_id;
    const client_secret = requestBody.client_secret;
    const cpf = event?.queryStringParameters?.cpf;
    
    let clienteIdentificado = {data:{
            anonimo: true
        }};
        
    let username;
    let password;

    try {

        // se informado o cpf, tenta identificar
        if(cpf){

            // obtencao de token via cognito
            const response = await axios.post(cognitoTokenUrl, null, {
                params: {
                    grant_type: 'client_credentials'
                },
                auth: {
                    username: client_id,
                    password: client_secret
                }
            });
            
            const token = response.data.access_token;
            
            // identificacao de usuario no sistema fast-n-foodious
            clienteIdentificado = await axios.post(`${apiGatewayUrl}v1/cliente/identifica?cpf=${cpf}`, null, {
                headers: {
                    'Authorization': `Bearer ${token}`
                },
            });

            console.log('clienteIdentificado', clienteIdentificado)

            // se identificado e sem credenciais
            if(clienteIdentificado.data.cpf && (!requestBody.username || !requestBody.password)){
                return {
                    statusCode: 401,
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ message: 'Credenciais inválidas' })
                };
            }
        }
               
    } catch (error) {
        console.error('Erro ao identificar o cliente', error);
        // retorno de erro na falha de autenticacao
        return {
            statusCode: 500,
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ message: 'Erro na identificação do cliente' })
        };
    }

    // se a identificacao anonima ou nao informado as credenciais de usuario, autentica com o user anomino
    if(clienteIdentificado.data.anonimo === true || !(requestBody.username || requestBody.password) || !cpf){
        username = process.env.COGNITO_FNF_USER_NAME
        password = process.env.COGNITO_FNF_USER_PASSWORD
    }else{
        username = requestBody.username;
        password = requestBody.password;
    }
    
    const secretHash = crypto.createHmac('SHA256', client_secret)
                        .update(username + client_id)
                        .digest('base64')
  
    const params = {
        AuthFlow: "USER_PASSWORD_AUTH",
        ClientId: client_id,
        AuthParameters: {
            USERNAME: username,
            PASSWORD: password,
            SECRET_HASH: secretHash
        }
    };

    console.log('params', params)

    const cognito = new AWS.CognitoIdentityServiceProvider({ region: "us-east-1" }); 

    try {
        const response = await cognito.initiateAuth(params).promise();

        return {
            statusCode: 200,
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({token: response.AuthenticationResult.IdToken})
        };
    } catch (error) {
        console.error('Erro ao autenticar o cliente', error);
        return {
            statusCode: 500,
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ message: "Erro na autenticação do cliente" })
        };
    }
};
