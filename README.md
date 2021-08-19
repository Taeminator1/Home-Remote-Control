# Home Remote Control(HRC)    <img width="20" alt="AppIcon" src="https://user-images.githubusercontent.com/68379110/122222344-22b83280-ceed-11eb-8fa5-dea72be9b464.png">
밖에서 집 안의 기기를 조작하기 위한 플랫폼

- [소개](#소개)
- [개발 정보](#개발-정보)
- [주요 기능](#주요-기능)
- [관련 링크](#관련-링크)

# 소개
인터넷을 이용해 NodeMCU(아두이노)와 iOS 앱을 연결한다. iOS 앱을 통해 서버의 상태를 변경하면, NodeMCU는 변경된 상태를 읽어, NodeMCU와 연결된 다양한 기기를 조작할 수 있다. 

![diagram](https://user-images.githubusercontent.com/68379110/130054789-6b2a9c9f-0c57-44c7-ad3e-a204f0c8cc3d.png)

# 개발 정보
- FW for NodeMCU
    - Directory: /Arduino
    - Language: C++
    - IDE: Arduino 1.8.15
- Server
    - Directory: /Server
    - Language: Node.js 14.17.2
    - IDE: Visual Studio Code 1.58.2
- Script Launcher
    - 자동으로 서버를 실행시켜주는 macOS 애플리케이션
    - Directory: /Xcode/Script Launcher
    - Language: Swift 4.2
    - IDE: Xcode 12.4
    - Deployment Target: 10.13
- HRC
    - iOS 애플리케이션
    - Directory: /Xcode/HRC
    - Language: Swift 5
    - IDE: Xcode 12.4
    - Deployment Target: 14.4
- 회로
    - Directory: /Others/Fritzing
    - SW: Fritzing 0.9.3
- 디자인
    - Directory: /Others/Symbol
    - SW: AdobeXD 27.1.12.4, Clip Studio 1.10.5

# 주요 기능
1. macOS 앱을 통해 서버(.js 파일)를 실행시킬 수 있다. 
2. iOS 앱 또는 웹 브라우저를 통해 NodeMCU에 부착된 기기들을 조작할 수 있다. 
    - 창문 닫기: 연결된 Motor Driver를 조작하여, Stepper를 작동시킨다. 
    - 에어컨 제어: 적외선 센서를 이용하여 집안에 설치된 에어컨을 켜고 끌 수 있다. 

# 관련 링크
사용 방법은 다음 [링크](https://taeminator1.tistory.com/66)를 통해 확인 가능하다. 

아래 링크에서 개발 과정을 자세하게 확인할 수 있다. 리스트 별로 번호가 부여되어 있는데, 해당 번호는 다음과 같은 주제를 다룬다. 
1. iOS App 개발
    1. [SwiftUI로 iOS Application UI 구성](https://taeminator1.tistory.com/10)
2. 앱과 웹 연결([아이폰 앱과 웹 페이지 간의 통신](https://taeminator1.tistory.com/12))
    1. [iOS 앱에서 JavaScript 함수 실행하기](https://taeminator1.tistory.com/13)
    2. [iOS에서 Web Scraping해서 정보 가져오기](https://taeminator1.tistory.com/14)
3. 서버 설정 및 웹페이지 작성
    1. [서버 할당과 웹페이지 작성](https://taeminator1.tistory.com/4)
    2. [웹 페이지 상태를 유지하는 방법 고찰](https://taeminator1.tistory.com/5)
    3. [Node.js를 이용한 웹 페이지 작성(개요)](https://taeminator1.tistory.com/6)
    4. Node.js를 이용한 웹 페이지 작성
    [1](https://taeminator1.tistory.com/8), 
    [2](https://taeminator1.tistory.com/9)
    5. [Script Launcher를 이용해 서버 실행시키기](https://taeminator1.tistory.com/65)
4. Node MCU 제어
    1. [Node MCU를 통해 Web Scraping해서 정보 가져오기](https://taeminator1.tistory.com/16)
5. 하드웨어 개발([하드웨어 파트 개발 계획](https://taeminator1.tistory.com/17))
    1. [창문 옮기기](https://taeminator1.tistory.com/22)
    2. 기구 제작
    [1](https://taeminator1.tistory.com/23)
    [2](https://taeminator1.tistory.com/24)
    3. [회로 설계 및 부품 실장](https://taeminator1.tistory.com/25)
    4. 아두이노 코딩
    [1](https://taeminator1.tistory.com/26)
    [2](https://taeminator1.tistory.com/27)
    [3](https://taeminator1.tistory.com/28)
    [4](https://taeminator1.tistory.com/29)
    5. [HRC 본체 설치](https://taeminator1.tistory.com/30)