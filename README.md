# robot-browser
Robot demo project with Robot Framework and Browser library against https://www.saucedemo.com/.

## Install
- install Python [virtual environment](https://packaging.python.org/en/latest/guides/installing-using-pip-and-virtual-environments/#creating-a-virtual-environment)
- install [Pip](https://pip.pypa.io/en/stable/installation/)
- pip install robotframework

For installing robotframework-browser lib see [installation guide](https://robotframework-browser.org/#installation)
- pip install robotframework-browser
- rfbrowser init

## Run Tests
- robot tests/suites/smoke/order_from_webshop.robot

## Additional stuff

### Example API tests
-  pip install robotframework-requests
-  robot tests/suites/api/api_tests.robot

### Example database tests (Postgres)
Start local Postgres DB with Docker:
- docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres

For running the tests:
- pip install robotframework-databaselibrary
- pip install psycopg2-binary
- robot tests/suites/smoke/database_test_large.robot

### Running tests in docker container
- Make [Dockerfile](./Dockerfile)
- Build dockerimage e.g. docker build -t my-robotframework-dockerimage . 

Run dockerimage:
- Runs all tests under current directory&subdirectories: docker run -v $(pwd):/opt/robotframework/tests --rm  my-robotframework-dockerimage 
- Runs specific test: docker run -v $(pwd):/opt/robotframework --rm  my-robotframework-dockerimage bash -c "robot --outputdir results tests/suites/smoke/order_from_webshop.robot"

Note: For DB tests in docker container you must allow container to listen host's port. Configure variable in Robot test: "${DBHOST}    host.docker.internal".
Another option to just test DB tests locally is to make docker-compose having both Robot container and Postgres container running as services in same network.

