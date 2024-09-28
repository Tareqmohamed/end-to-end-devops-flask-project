import http.server
import socketserver
import requests

def get_instance_id():
    try:
        # Step 1: Get the session token
        token_url = "http://169.254.169.254/latest/api/token"
        token_headers = {"X-aws-ec2-metadata-token-ttl-seconds": "21600"}
        token_response = requests.put(token_url, headers=token_headers, timeout=2)
        token = token_response.text

        # Step 2: Use the token to get the instance ID
        instance_id_url = "http://169.254.169.254/latest/meta-data/instance-id"
        instance_id_headers = {"X-aws-ec2-metadata-token": token}
        instance_id_response = requests.get(instance_id_url, headers=instance_id_headers, timeout=2)
        return instance_id_response.text
    except requests.RequestException as e:
        return f"Unable to retrieve instance ID: {str(e)}"

class MyHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/':
            self.send_response(200)
            self.send_header("Content-type", "text/plain")
            self.end_headers()
            instance_id = get_instance_id()
            self.wfile.write(f"This page is from a simple application that prints the following message. I uploaded the application to CodeCommit and created a Dockerfile to build an image and run a container to host the application. I set up an IAM role to allow the instance to pull the code and wrote a Bash script to download the necessary dependencies, pull the code from CodeCommit, and run the container to access the application. Additionally, I implemented an ELB to distribute traffic and configured auto-scaling to ensure high availability. EC2 Instance ID: {instance_id}".encode())
        else:
            super().do_GET()

if __name__ == "__main__":
    PORT = 5000
    with socketserver.TCPServer(("", PORT), MyHandler) as httpd:
        print(f"Server running on port {PORT}")
        httpd.serve_forever()