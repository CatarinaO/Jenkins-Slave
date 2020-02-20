pipeline {
    agent {
      dockerfile {
        filename 'Dockerfile'
        label 'master-slave-node'
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

