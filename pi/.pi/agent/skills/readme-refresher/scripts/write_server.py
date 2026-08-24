#!/usr/bin/env python3
"""
Lokal server som tar emot README-uppdateringar från HTML-gränssnittet
och skriver dem direkt till fil.

Användning:
    python write_server.py /path/to/README.md

Startar en server på http://localhost:8765
När HTML-sidan POSTar till /save, sparas innehållet till filen.
"""

import http.server
import socketserver
import json
import sys
import os
from urllib.parse import parse_qs

PORT = 8768


class ReadmeHandler(http.server.BaseHTTPRequestHandler):
    """Handler som tar emot och sparar README-ändringar."""

    def do_GET(self):
        """Serve the HTML interface."""
        if self.path == '/' or self.path == '/index.html':
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            with open('/tmp/readme-interface.html', 'r') as f:
                self.wfile.write(f.read().encode('utf-8'))
        else:
            self.send_error(404)

    def do_POST(self):
        """Ta emot och spara README-innehåll."""
        if self.path == '/save':
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            
            try:
                data = json.loads(post_data.decode('utf-8'))
                content = data.get('content', '')
                readme_path = data.get('path', '')
                
                if not readme_path:
                    self.send_json_response({'success': False, 'error': 'Ingen sökväg angiven'})
                    return
                
                # Skriv till fil
                with open(readme_path, 'w') as f:
                    f.write(content)
                
                self.send_json_response({'success': True, 'message': f'Sparat till {readme_path}'})
                print(f"✅ Sparat README till {readme_path}")
                
            except Exception as e:
                self.send_json_response({'success': False, 'error': str(e)})
        elif self.path == '/open':
            # Öppna filen i standardprogram
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            data = json.loads(post_data.decode('utf-8'))
            path = data.get('path', '')
            if path:
                os.system(f'open "{path}" 2>/dev/null || xdg-open "{path}" 2>/dev/null')
                self.send_json_response({'success': True})
        else:
            self.send_error(404)

    def send_json_response(self, data):
        """Skicka JSON-svar."""
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()
        self.wfile.write(json.dumps(data).encode('utf-8'))

    def log_message(self, format, *args):
        """Minska loggvolymen."""
        try:
            msg = str(args[0]) if args else str(format)
            if 'save' in msg:
                pass  # Tyst för save-requests
            else:
                super().log_message(format, *args)
        except:
            pass


def main():
    if len(sys.argv) < 2:
        print("Användning: python write_server.py <path-to-readme.md>")
        print("Startar server på http://localhost:8765")
        readme_path = '/tmp/README.md'
    else:
        readme_path = os.path.abspath(sys.argv[1])

    print(f"📝 README Path: {readme_path}")
    print(f"🌐 Öppna: http://localhost:{PORT}")
    print()
    print("Vänta på att HTML-gränssnittet skickar ändringar...")
    print("Ctrl+C för att stoppa")
    print()

    # Spara sökvägen så HTML-sidan kan hämta den
    with open('/tmp/readme_path.txt', 'w') as f:
        f.write(readme_path)

    with socketserver.TCPServer(("", PORT), ReadmeHandler) as httpd:
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\n👋 Server stoppad")
            sys.exit(0)


if __name__ == '__main__':
    main()
