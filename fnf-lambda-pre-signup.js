const axios = require("axios");

exports.handler = async (event) => {
    
    if(event.request.userAttributes['custom:anonimo'] === 'true'){
        return event
    }

    // obtencao de URLs do api gateway e cognito
    const apiGatewayUrl = process.env.API_GATEWAY_URL;
    const cognitoTokenUrl = `${process.env.API_COGNITO_URL}oauth2/token`;
    const client_id = process.env.CLIENT_ID
    const client_secret = process.env.CLIENT_SECRET
    
    try {

        // obtencao de token via cognito
        var response = await axios.post(cognitoTokenUrl, null, {
            params: {
                grant_type: 'client_credentials'
            },
            auth: {
                username: client_id,
                password: client_secret
            }
        });
        
        const token = response.data.access_token;

        const cliente ={
            nome: event.request.userAttributes.name,
            email: event.request.userAttributes.email,
            cpf: event.request.userAttributes['custom:cpf']
        }
            
        // add usuario no sistema fast-n-foodious
        response = await axios.post(`${apiGatewayUrl}v1/cliente`, cliente, {
            headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
            },
        });

        console.log('response-->> ', response)
               
    } catch (error) {
        console.error('Erro ao cadastrar o cliente no FNF', error);
        // retorno de erro na falha de autenticacao
        return {
            statusCode: 500,
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ message: 'Erro ao cadastrar cliente' })
        };
    }

    return event
};
