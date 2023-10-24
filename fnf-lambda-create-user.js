const AWS = require("aws-sdk");

exports.handler = async (event) => {

    const requestBody = JSON.parse(event.body);

    const nome = requestBody.nome;
    const email = requestBody.email;
    const password = requestBody.password;
    const cpf = requestBody.cpf;

    const cognito = new AWS.CognitoIdentityServiceProvider({ region: "us-east-1" });

    try{

        var params = {
            UserPoolId: process.env.POOL_ID,
            Username: email,
            UserAttributes: [
                { Name: "name", Value: nome },
                { Name: "email", Value: email },
                { Name: "custom:cpf", Value: cpf },
                { Name: "email_verified", Value: "true" },
                { Name: "custom:anonimo", Value: "false" }
            ]
        };

        // cadastra usuario
        var response = await cognito.adminCreateUser(params).promise()
        console.log('Usuario cadastrado cognito', response)

        params = {
            UserPoolId: process.env.POOL_ID,
            Username: email,
            Password: password,
            Permanent: true
        };
    
        // atualiza senha do usuario usuario
        response = await cognito.adminSetUserPassword(params).promise()

        console.log('senha atuailzada cognito', response)

        return {
            statusCode: 201
        };

    } catch (error) {
        console.error('Erro ao cadastrar usuario no cognito', error)
        return {
            statusCode: 500,
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ message: 'Erro ao cadastrar usuario no Idp' })
        };
    }

};
