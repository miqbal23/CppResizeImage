#include "libasyik/service.hpp"
#include "libasyik/http.hpp"

using namespace asyik;

int main(int argc, char const *argv[])
{
  auto as = asyik::make_service();
  auto server = asyik::make_http_server(as, "127.0.0.1", 4004);

  // accept string argument
  server->on_http_request("/name/<string>", "GET", [](auto req, auto args)
  {
    req->response.body = "Hello " + args[1] + "!";
    req->response.result(200);
  });
  
  // accept string and int arguments
  server->on_http_request("/name/<string>/<int>", "GET", [](auto req, auto args)
  {
    req->response.body = "Hello " + args[1] + "! " + "int=" + args[2];
    req->response.result(200);
  });
  
  as->run();

  return 0;
}
