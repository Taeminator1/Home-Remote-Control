var http = require('http');
var fs = require('fs');
var url = require('url');
var qs = require('querystring');

const inPort = 0;            // 내부 포트 번호
 
function loadHTML(readStr) {
  return `
  <!doctype html>
    <html>
    <head>
      <title>Hmoe Remote Contorl</title>
      <meta charset='utf-8'>
    </head>
    <body>
      <form action='/create' method='post'>
        <h3>Test Buttons</h3>
        <ul>
          <li>
            <label><input type='checkbox' name='test1' id='btn1'> button1 </label>
            <label id = 'label1'> ${readStr[0]} </label>
          </li>
          <li>
            <label><input type='checkbox' name='test2' id='btn2'> button2 </label>
            <label id = 'label2'> ${readStr[1]} </label>
          </li>
            <p><input type='hidden' id='save'></p>
        </ul>
      </form>

      <script>
        window.onload = function() {                          // 웹페이지가 로드될 때 실행
          document.getElementById('btn1').checked = ${readStr[0]};
          document.getElementById('btn2').checked = ${readStr[1]};

          setHTMLState('label1', 'btn1')
          setHTMLState('label2', 'btn2')
        }

        // btn의 상태값 변경시키는 EventListener 생성
        setEventListener(btn1, 'btn1', 'label1');
        setEventListener(btn2, 'btn2', 'label2');
        
        function setEventListener(btn, btnId, labelId) {
          btn.addEventListener('click', (event) => {    
            setHTMLState(labelId, btnId)
            saveHTMLState('save')                             // checkbox 누를 때마다 상태 save
          });
        }

        function setHTMLState(labelId, btnId) {
          document.getElementById(labelId).innerHTML = document.getElementById(btnId).checked ? 'on' : 'off';
        }

        function saveHTMLState(id) {
          document.getElementById(id).form.submit();
        }
       
        function buttonClicked(btn) {     // iOS 앱에서 접근 가능하도록 함수 정의
          document.getElementById(btn).click();
        }
      </script>
    </body>
    </html>
  `;
}

var app = http.createServer(function(request,response){
  var baseURL = 'http://' + request.headers.host + '/';
  var pathname = new URL(request.url, baseURL).pathname
  var title = 'data.txt';

  if(pathname === '/'){           // URL에 주소 입력시 동작
    if (!fs.existsSync(`${title}`)) {     // data.txt 파일이 존재하지 않으면 파일 생성
      fs.writeFile(`${title}`, 'false/false/', 'utf8', function(err){
        response.writeHead(302, {Location: `/?id=${title}`});
        response.end();
      });
    }
    else {                                // data.txt 파일이 존재하면 파일 읽기
      fs.readFile(`${title}`, 'utf8', function(err, description){
        var readStr = description.split('/');
        console.log('Success reading file')
        response.writeHead(200);
        response.end(loadHTML(readStr));
      });
    }
  } 
  else if(pathname === '/create'){      // submit 버튼 누를 시 동작
    var body = '';
    request.on('data', function(data){
      body = body + data;
    });
    request.on('end', function(){
      var post = qs.parse(body);

      var description = '';
      description += saveState(post.test1)
      description += saveState(post.test2)
      
      fs.writeFile(`${title}`, description, 'utf8', function(err){
        response.writeHead(302, {Location: `/?id=${title}`});
        response.end();
        console.log('Success writing file')
      });
    });
  } 
  else {
    response.writeHead(404);
    response.end('Not found');
  }
});

app.listen(inPort, function() {
  console.log('HRC node.js is running on port %d', inPort);
});

function saveState(buttonState) {
  return buttonState == 'on' ? 'true/' : 'false/';
}