stateDiagram-v2
    [*] --> Deploy
    Deploy --> OptIn
    OptIn --> Propose
    Propose --> Vote
    Vote --> Activate
    Activate --> Invoke
    Vote --> Deactivate
    Invoke --> [*]
