(import 
  (scheme base)
  (scheme write)
  
  ;; sockets
  (class java.net Socket ServerSocket)
  (class javax.net.ssl SSLServerSocketFactory SSLServerSocket)
  
  ;;input stream
  (class java.io InputStreamReader BufferedReader PrintWriter)
  (class java.nio.charset StandardCharsets)
  (class java.util.stream Collectors))

(define (create-ssl-server-socket port) ::ServerSocket
  (define socket-factory (SSLServerSocketFactory:getDefault))
  (define socket (socket-factory:createServerSocket port))
  socket)

(define (socket-read-string socket ::Socket)
  (define isr (InputStreamReader (socket:getInputStream) StandardCharsets:UTF_8))
  (define br (BufferedReader isr))
  (define lines-stream (br:lines))
  (define str (lines-stream:collect (Collectors:joining "\n")))
  str)

(define (socket-write-string socket ::Socket str)
  (define writer (PrintWriter (socket:getOutputStream)))
  (writer:println str)
  (writer:flush))

(define socket (create-ssl-server-socket 8080))
(display "Listening..")
(newline)
(let loop ()
 (define client-socket (socket:accept))
 (define received (socket-read-string client-socket))
 (display "Connected\nReceived: ")
 (display received)
 (newline)
 ;; Not sure if s_client not receiving
 ;; or just not printing?
 ;;(socket-write-string client-socket (string-append "Response to " received))
 (client-socket:close)
 (loop))
