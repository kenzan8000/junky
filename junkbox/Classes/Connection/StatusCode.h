#pragma mark - namespace
namespace http {
#   pragma mark - constant
    namespace statusCode {
        static const int SUCCESS = 200;         //2xx
        static const int REDIRECTION = 300;     //3xx
        static const int CLIENT_ERROR = 400;    //4xx
        static const int SERVER_ERROR = 500;    //5xx
        static const int ERROR = 400;           //error -> statusCode >= 400

        //2xx Success
        static const int OK = 200;
        //3xx Redirection
        //4xx Client Error
        static const int BAD_REQUEST = 400;
        static const int UNAUTHORIZED = 401;
        static const int FORBIDDEN = 403;
        static const int NOT_FOUND = 404;
        //5xx Server Error
        static const int INTERNAL_SERVER_ERROR = 500;
        static const int SERVICE_UNAVAILABLE = 503;
    }

    // not reachable
    static const int NOT_REACHABLE = 600;
    // connection timeout
    static const int TIMEOUT = 601;
}
