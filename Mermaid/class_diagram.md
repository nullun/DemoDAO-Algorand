classDiagram
    DAO --> Functionality
    class DAO {
        + uninitialised
        + asset_id
        + proposal_[app_id]
        + proposal_[app_id]_for
        + proposal_[app_id]_against
        + deploy()
        + optin()
        + proposal()
        + vote()
        + activate()
        + deactivate()
        + invoke()
    }
    class Functionality {
        + [unknown]
        + deploy()
        + deactivate()
        + invoke()
    }
