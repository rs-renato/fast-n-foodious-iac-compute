const axios = require("axios");
const AWS = require("aws-sdk");

exports.handler = async (event) => {
    
    // obtencao de URLs do api gateway e cognito
    const apiGatewayUrl = process.env.API_GATEWAY_URL;
    const cognitoTokenUrl = `${process.env.API_COGNITO_URL}oauth2/token`;
    const client_id = process.env.CLIENT_ID
    const client_secret = process.env.CLIENT_SECRET
    let response

    try {

        // obtencao de token via cognito
        var respAuth = await axios.post(cognitoTokenUrl, null, {
            params: {
                grant_type: 'client_credentials'
            },
            auth: {
                username: client_id,
                password: client_secret
            }
        });
        
        const token = respAuth.data.access_token;
        const cpf = event?.queryStringParameters?.cpf;

        // deleta usuario no sistema fast-n-foodious
        await axios.delete(`${apiGatewayUrl}v1/cliente/?cpf=${cpf}`, {
            headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
            },
        }).then(async(resp) => {
            try{
                
                console.log(`Usuário deletado com sucesso na aplicação`);

                const cognito = new AWS.CognitoIdentityServiceProvider({ region: "us-east-1" });
                
                var params = {
                    UserPoolId: process.env.POOL_ID,
                    Username: cpf
                };

                // cadastra usuario
                await cognito.adminDeleteUser(params).promise()
                console.log(`Usuário deletado com sucesso no cognito`);

                response = {
                    statusCode: resp.status,
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(resp.data)
                };

            } catch (error) {
                console.error('Erro ao deletar usuario no cognito', error)
                response = {
                    statusCode: 500,
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ message: 'Erro ao deletar cliente no Idp' })
                };
            }
        })
        .catch(error => {
            console.error('Erro ao deletar cliente da aplicação', error)
            response = {
                statusCode: error.response.status,
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(error.response.data)
            };
        });
               
    } catch (error) {
        console.error('Erro ao deletar o cliente', error);
        response = {
            statusCode: 500,
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ message: 'Erro ao deletar cliente' })
        };
    }

    return response;
};
