# robot-browser
Robot demo project with Robot Framework and Browser library against https://www.saucedemo.com/.

## Install
- install Python [virtual environment](https://packaging.python.org/en/latest/guides/installing-using-pip-and-virtual-environments/#creating-a-virtual-environment)
- install [Pip](https://pip.pypa.io/en/stable/installation/)
- pip install robotframework
- pip install robotframework-browser
- rfbrowser init (see [installation guide](https://robotframework-browser.org/#installation))

## Run Tests
- robot tests/suites/smoke/order_from_webshop.robot

## Additional stuff

### Example API tests
-  pip install robotframework-requests
-  robot tests/suites/api/api_tests.robot

### Example database tests (Postgres)
- pip install robotframework-databaselibrary
- pip install psycopg2-binary
- robot tests/suites/smoke/database_test_large.robot

