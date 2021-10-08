//
//  app.js
//
//  Create by Taemin Yun on 7/26 /20
//

//  Operate server in specific port of router.
//  It includes HTML.
//  The file is able to excuted by typing "node app.js" or running "Script Launcher" app.
//  Before run, you should assign internal port number to inPort variable.

var http = require('http');
var fs = require('fs');
var qs = require('querystring');

const inPort = 0;            // Internal Port Number
 
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
        window.onload = function() {                          // When page is loaded,
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
            saveHTMLState('save')                             // Whenever checkbox is clicked, state is saved.
          });
        }

        function setHTMLState(labelId, btnId) {
          document.getElementById(labelId).innerHTML = document.getElementById(btnId).checked ? 'on' : 'off';
        }

        function saveHTMLState(id) {
          document.getElementById(id).form.submit();
        }
       
        function buttonClicked(btn) {                         // Function to use in iOS App
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
  var title = 'data.txt';         // Name of file to store button' state.

  if(pathname === '/'){           // When write address in browser,
    if (!fs.existsSync(`${title}`)) {     // If data.txt file doesn't exist, create the file.
      fs.writeFile(`${title}`, 'false/false/', 'utf8', function(err){
        response.writeHead(302, {Location: `/?id=${title}`});
        response.end();
      });
    }
    else {                                // If data.txt file exists, read the file.
      fs.readFile(`${title}`, 'utf8', function(err, description){
        var readStr = description.split('/');
        console.log('Success reading file')
        response.writeHead(200);
        response.end(loadHTML(readStr));
      });
    }
  } 
  else if(pathname === '/create'){        // When submit button is pushed,
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