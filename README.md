### Automating tasks on Codementor


#### REQUIREMENTS
* [NodeJs]()
* Chrome Web Driver
    * You can install chrome driver from [here]()
    * The driver needs to be placed in the project's `bin` folder
* [JDK]()

#### SETUP
* Install the necessary npm dependencies:
    > ```bash
    > npm i
    > ```

* Setup the to make it available
    > ```bash
    > bash src/automentor.bash setup
    > ```

#### USAGE
* You need to first login into your codementor account via the automator:
    > ```bash
    > automentor login
    > ```
    This stores the cookie information from your login into `src/cookie.js` for future reuse

* You can visit the request page with:
    > ```bash
    > automentor requests
    > ```
    Th
