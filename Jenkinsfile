pipeline {
    agent {
      dockerfile {
        filename 'Dockerfile'
        label 'master-slave'
      }
    }


    options {
      disableConcurrentBuilds()
    }

    stages {
      stage('Install ArgoCD in the Cluster') {
        steps {

        sh '''
             mkdir dhdhd
             '''

        }
     }
   }
}

