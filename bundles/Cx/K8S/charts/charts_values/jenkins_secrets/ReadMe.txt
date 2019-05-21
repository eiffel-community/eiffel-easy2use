Jenkins uses the master.key to encrypt the key hudson.util.Secret. This key is then used to encrypt the password in credentials.xml.

If psw changed download credentials.xml, hudson.util.Secret & master.key master.key:

 kubectl get pods -n <namespace>
     -> Fetch the podname for Jenkins!

 Copy files from pod to local machine:
 kubectl cp <namespace>/<podname>:/var/jenkins_home/credentials.xml credentials.xml
 kubectl cp <namespace>/<podname>:/var/jenkins_home/secrets/hudson.util.Secret hudson.util.Secret
 kubectl cp <namespace>/<podname>:/var/jenkins_home/secrets/master.key master.key


 place copied files into Easy2Use Cx bundle path:
        ..bundles\Cx\K8S\charts\charts_values\jenkins_secrets