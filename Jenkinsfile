pipeline {
    agent {
      dockerfile {
        filename 'Dockerfile'
        label 'slave-node'
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

