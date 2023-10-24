exports.handler = async(event) => {

    event.response = {
      claimsOverrideDetails: {
        claimsToAddOrOverride: {
          ...(event.request.userAttributes['custom:cpf'] ? { cpf: event.request.userAttributes['custom:cpf'] } : { anonimo: event.request.userAttributes['custom:anonimo'] })
        }
      }
    };

  return event;
};