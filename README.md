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

Note: For DB tests in docker container you must allow container to listen host's port. Configure variable in Robot test: "${DBHOST}    host.docker.internal".
Another option to just test DB tests locally is to make docker-compose having both Robot container and Postgres container running as services in same network.

### Running tests in docker container
- Use [Dockerfile](./Dockerfile)
- Build dockerimage e.g. docker build -t my-robotframework-dockerimage . 

Run dockerimage:
- Runs all tests under current directory&subdirectories: docker run -v $(pwd):/opt/robotframework/tests --rm  my-robotframework-dockerimage 
- Runs specific test: docker run -v $(pwd):/opt/robotframework --rm  my-robotframework-dockerimage bash -c "robot --outputdir results tests/suites/smoke/order_from_webshop.robot"

### Running tests in local Jenkins pipeline
- Ensure Docker daemon is running e.g. with Docker Desktop
- Start Docker jenkins 
  - https://github.com/jenkinsci/docker/blob/master/README.md
  - docker run -p 8080:8080 -p 50000:50000 --restart=on-failure -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts-jdk17
- Install Vagrant and Vagrant VMWare Utility (Note: use ARM64 for Apple Silicon Mac):
  - https://developer.hashicorp.com/vagrant/install 
  - https://developer.hashicorp.com/vagrant/install/vmware
- Install virtualization app e.g. VMWare Fusion (for AMD processors also the Virtualbox works):
   - See: https://gist.github.com/fatso83/49980bbf065022d36c3a42369479a8df  
- Start Vagrant box in folder containing [Vagrantfile](./Vagrantfile): vagrant up (Note: for ARM64)
  - in VMWare console you can log in with vagrant/vagrant
  - get SSH connection from host machine (e.g. Mac) to box with: vagrant ssh
- In Vagrantbox console install JDK17: sudo apt-get install openjdk-17-jdk
- In Vagrantbox console install Docker e.g with: sudo apt-get update && sudo apt install docker.io
- Use [Dockerfile](./Dockerfile)
- Use [Jenkinsfile](./Jenkinsfile), see basic example from this video: https://www.youtube.com/watch?v=ymI02j-hqpU&t=53s
- Add Jenkins agent/node on Jenkins master/controller (https://www.jenkins.io/doc/book/managing/nodes/)
  - Manage Jenkins - Nodes - New Node
  - Add name, add number or executors as 2.
  - Add 'Remote root directory' as e.g. /home/vagrant/jenkins
  - Set Launch method as 'Launch agent by connecting it to controller' + Save
- Connect JNLP agent to master with guidance of new node in Jenkins master e.g:
  -   java -jar agent.jar -url http://<jenkins controller private ip>:8080/ -secret <secret> -name "vagrant-node" -webSocket -workDir "/home/vagrant/jenkins"
  - As response you should get 'INFO: Connected' in console.
- Add new job i.e. 'New Item' in Jenkins master UI
  - Add name and select 'Pipeline' + OK.
  - Select 'Pipeline Script from SCM'
  - Set Repository URL as: https://github.com/jaheikki/robot-browser.git and Branch Specifier as '*/main'.
  - In Script Path set: Jenkinsfile + SAVE
- Setting jenkins is ready so start job by 'Build now' in job/item menu.
  - Robot tests should run parallelly and PASS
  - You should see Robot test reports for both executors under job's number link.





