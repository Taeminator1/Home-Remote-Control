var http = require('http');
var fs = require('fs');
var url = require('url');
var qs = require('querystring');

const inPort = ;            // 내부 포트 번호
 
function loadHTML(readStr) {
  return `
  <!doctype html>
    <html>
    <head>
      <title>Hmoe Remote Contorl</title>
      <meta charset="utf-8">
    </head>
    <body>
      <form action="/create" method="post">
        <h3>Test Buttons</h3>
        <ul>
          <li>
            <label><input type="checkbox" name="test1" id="btn1"> button1 </label>
            <label id = "label1"> ${readStr[0]} </label>
          </li>
          <li>
            <label><input type="checkbox" name="test2" id="btn2"> button2 </label>
            <label id = "label2"> ${readStr[1]} </label>
          </li>
            <p><input type="hidden" id="save"></p>
        </ul>
      </form>
      <script>
        var writtenStr = ["", ""];
        writtenStr[0] = ${readStr[0]};
        writtenStr[1] = ${readStr[1]};

        // 웹페이지가 로드될 때 실행
        window.onload = function() {
          document.getElementById('btn1').checked = ${readStr[0]};
          document.getElementById('btn2').checked = ${readStr[1]};

          if(document.getElementById('btn1').checked) {
            document.getElementById('label1').innerHTML = 'on';
          } else {
            document.getElementById('label1').innerHTML = 'off';
          }

          if(document.getElementById('btn2').checked) {
            document.getElementById('label2').innerHTML = 'on';
          } else {
            document.getElementById('label2').innerHTML = 'off';
          }
        }

        // btn1의 상태값 변경시키는 EventListener
        btn1.addEventListener('click', (event) => {    
          if(document.getElementById('btn1').checked) {
            document.getElementById('label1').innerHTML = 'on'; 
            writtenStr[0] = "true";
          } else {
            document.getElementById('label1').innerHTML = 'off'; 
            writtenStr[0] = "false";
          }
          document.getElementById('save').form.submit();            // checkbox 누를 때마다 상태 save
        });
        // btn2의 상태값 변경시키는 EventListener
        btn2.addEventListener('click', (event) => {    
          if(document.getElementById('btn2').checked) {
            document.getElementById('label2').innerHTML = 'on'; 
            writtenStr[1] = "true";
          } else {
            document.getElementById('label2').innerHTML = 'off'; 
            writtenStr[1] = "false";
          }
          document.getElementById('save').form.submit();            // checkbox 누를 때마다 상태 save
        });

        // Javascript Function
        function btn1ButtonClicked() {
          document.getElementById('btn1').click();
        }
        function btn2ButtonClicked() {
          document.getElementById('btn2').click();
        }
      </script>
    </body>
    </html>
  `;
}

var app = http.createServer(function(request,response){
    var _url = request.url;
    var pathname = url.parse(_url, true).pathname;
    if(pathname === '/'){           // URL에 주소 입력시 동작
        fs.readFile('data.txt', 'utf8', function(err, description){
            var readStr = description.split("/");
            console.log("Success reading file")
            response.writeHead(200);
            response.end(loadHTML(readStr));
      });
    } else if(pathname === '/create'){      // submit 버튼 누를 시 동작
      var body = '';
      request.on('data', function(data){
        body = body + data;
      });
      request.on('end', function(){
        var post = qs.parse(body);
        var title = "data.txt";
        var description = "";
        if(post.test1 == "on") {
          description = "true/";
        } else {
          description = "false/";
        }
        if(post.test2 == "on") {
          description = description + "true";
        } else {
          description = description + "false";
        }

        fs.writeFile(`${title}`, description, 'utf8', function(err){
          response.writeHead(302, {Location: `/?id=${title}`});
          response.end();
          console.log("Success writing file")
        });
      });
    } else {
      response.writeHead(404);
      response.end('Not found');
    }
});
app.listen(inPort, function() {       // 내부 포트 번호: 80, 외부 포트 번호는 웹브라우저의 주소창에 입력
  console.log("HRC node.js is running on port %d", inPort);
});
