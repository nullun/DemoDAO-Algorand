sequenceDiagram
    User ->> DAO: Deploy DAO
    User ->> DAO: OptIn
    par Propose Functionality
    User ->> Reference Functionality: Deploy Func Ref
    User ->> DAO: Propose
    end
    User ->> DAO: Vote
    par Deploy Functionality
    User ->> DAO: Activate
    DAO ->> DAO Functionality: Deploy Func
    end
    User ->> Reference Functionality: Deactive
    par Invoke Functionality
    User ->> DAO: Invoke
    DAO ->> DAO Functionality: Call
    end
