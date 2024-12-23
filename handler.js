module.exports.handler = function (event, context, callback) {
    console.log("Event: ", JSON.stringify(event, null, 2));

    // Leer el token del evento
    var token = event.authorizationToken;

    // Validar el token
    switch (token) {
        case 'allow':
            callback(null, generatePolicy('user', 'Allow', event.methodArn));
            break;
        case 'deny':
            callback(null, generatePolicy('user', 'Deny', event.methodArn));
            break;
        case 'unauthorized':
            callback("Unauthorized"); // Devuelve un error 401
            break;
        default:
            callback(null, generatePolicy('user', 'Deny', event.methodArn)); // Devuelve un Deny si el token es inválido
    }
};

// Función auxiliar para generar una política válida
var generatePolicy = function (principalId, effect, resource) {
    if (!effect || !resource) {
        throw new Error("Invalid policy parameters");
    }

    var authResponse = {
        principalId: principalId,
        policyDocument: {
            Version: "2012-10-17",
            Statement: [
                {
                    Action: "execute-api:Invoke",
                    Effect: effect,
                    Resource: resource,
                },
            ],
        },
        context: {
            stringKey: "value",
            numberKey: 123,
            booleanKey: true,
        },
    };

    return authResponse;
};
