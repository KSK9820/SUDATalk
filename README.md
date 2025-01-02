# 수다톡
> 컴퓨터 언어 공부 같이 하자!
>
> 다양한 컴퓨터 언어 워크스페이스에서 함께 스터디할 수 있도록 DM과 그룹챗으로 **실시간** 소통할 수 있는 커뮤니티

<br/>
 
## **프로젝트 환경**
- 인원: iOS 개발자 2명, backend 개발자 1명

<table style="width: 100%; border-collapse: collapse; table-layout: fixed;">
  <thead>
    <tr>
      <th style="background-color: #f4f4f4; width: 50%;">김수경</th>
      <th style="background-color: #f4f4f4; width: 50%;">박다현</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <div align="center"><img src="https://avatars.githubusercontent.com/u/68066104?v=4" style="width: 200px;"></div>
      </td>
      <td>
        <div align="center"><img src="https://avatars.githubusercontent.com/u/85213387?v=4" style="width: 200px;"></div>
      </td>
    </tr>
    <tr>
      <td colspan="2">(공통) 네트워크 설계(Socket, REST API 통신)</td>
    </tr>
    <tr>
      <td>DM 목록, DM 채팅, 워크스페이스</td>
      <td>GroupChat 목록, GroupChat 채팅, HomeView</td>
    </tr>
  </tbody>
</table>


- 기간: 2024년 10월 30일 - 12월 13일(6주)
- 최소 버전: iOS 16 +
- 기술 스택
    - **Reactive Programming**: SwiftUI + Combine
    - **Architecture**: MVI + Reducer
    - **Network**: URLSession, SocketIO
    - **Data Base**: Realm
    - **Co-Work**: SwiftLint, Git Flow
    - **Swift Concurrency**

<br/>

## 주요기능

- `홈 화면` : 워크 스페이스 및 Group 채팅과 DM 채팅을 확인할 수 있는 화면
    - `ScreenEdgePanGesture`를 했을 때 [워크스페이스 목록 화면]을 조회할 수 있습니다.
    - 워크스페이스별 `GroupChat(그룹 채팅)` 목록과 `DM(개인 채팅)`을 조회할 수 있습니다.
- `DM 화면` : 워크스페이스의 멤버와 DM 목록을 조회할 수 있는 화면
    - 워크 스페이스의 멤버 프로필을 선택하면 해당 멤버와의 [DM 화면]으로 이동합니다.
    - DM 목록에는 멤버, 읽지 않은 채팅의 개수, 마지막 채팅 내용을 조회할 수 있습니다.
    - DM 목록을 선택하면 해당 [DM 화면]으로 이동합니다.
- `GroupChat 화면` : 워크 스페이스의 전체 GroupChat 목록을 조회할 수 있습니다.
    - 유저가 속한 GroupChat과 속하지 않은 GroupChat 모두를 조회할 수 있습니다.
    - 유저가 속한 GroupChat을 선택할 경우, 해당 [GroupChat 화면]으로 이동합니다.
    - 유저가 속하지 않은 채널을 선택할 경우, 해당 GroupChat 참여 팝업을 통해서 GroupChat에 참여할 수 있습니다.
- `채팅 화면`
    - 메세지와 이미지를 실시간으로 송수신할 수 있습니다.
    - GroupChat의 경우 그룹 채팅 생성, 삭제, 편집을 할 수 있습니다.
 
<br/>


## 화면
| 홈 뷰 | 실시간 채팅(DM) | 이미지 송신(그룹챗) |
|-|-|-|
|![홈뷰](https://github.com/user-attachments/assets/6480d117-8ad9-445e-8d42-73528aa2bb78)|![디엠3](https://github.com/user-attachments/assets/bb4bf07b-9cbf-4fb9-97d0-b8da1c7b16d3)|![그룹챗_이미지](https://github.com/user-attachments/assets/e5f812b6-c386-4df9-bc2e-b58534ad90fc)|
| 워크스페이스 | 이미지 송수신(2개) | 그룹챗 설정 |
|![simulator_screenshot_D047B1FD-1BD8-4779-823E-57769D82A645](https://github.com/user-attachments/assets/52d47dbc-3dd4-476b-9ebb-46104054fc60)|![그룹챗뷰2](https://github.com/user-attachments/assets/133b747e-c81f-489e-ac1f-655750dc739f)|![그룹챗설정2](https://github.com/user-attachments/assets/8272e5c3-17f2-4ab2-850b-1f2adcae0bb9)|

<br/>

## 아키택처
![Untitled FigJam jpg](https://github.com/user-attachments/assets/011c0233-4b6e-4181-92de-6b138343153d)


- `Container`: `Model`과 `Intent`를 연결하는 중심 역할
    - model - State와 Action을 가짐
        - State와 Action을 각 View에 맞게 `Protocol`로 추상화하여 상태와 동작을 독립적으로 정의
    - intent - 사용자의 액션을 처리하고, 이를 통해 Model을 업데이트
        - enum 타입을 사용해서 모델의 메서드와 연결되어 비즈니스 로직을 수행
- builder 패턴: 객체 생성과 초기화의 복잡한 과정을 `build` 메서드에 캡슐화하여, 외부에서 View를 쉽게 생성

## 기술 스택 상세

- **네트워크(HTTP 통신)**
    - 네트워크 통신의 **구성 요소와 URLRequst의 분리**
      - `EndpointConfigurable` 프로토콜을 사용하여 각 `Endpoint`의 구성 요소를 명세합니다.
      - `EndPointConfigurable` 프로토콜이 **`URLRequestConvertible`** 프로토콜을 별도로 채택하여 네트워크 요청을 수행할 준비를 하는 `URLRequest`를 생성합니다.
    
      → 이를 통해 **SOLID의 단일 책임 원칙(SRP)** 을 준수하며, 이를 통해 코드의 유지보수성과 확장성을 높였습니다.
    
   - Login, Workspace, GroupChat, DM 등 각 기능별로 **개별 Router를 생성하여 관리**
     - 각 가능의 네트워크 요청을 라우터 별로 독립적으로 모듈화하였습니다.
     - 공통 라우팅 로직을 캡슐화하여 재사용성을 높이고, 새로운 라우트 추가 시 기존 코드에 영향을 최소화할 수 있도록 확장성이 높은 구조를 유지할 수 있게 하였습니다.
    
   - MockURLSession을 사용한 네트워크 테스트
     - `URLSessionProtocol`을 따르는 `MockURLSession`을 `NetworkManager`에 DIP 하여 테스트 가능한 네트워크 매니저를 생성했습니다. 이를 통해 실제 네트워크 통신 없이 mock data를 사용하여 네트워크 요청에 대한 정확한 응답 처리 및 예외 처리가 제대로 이루어지는지 검증할 수 있었습니다.
  - **에러 처리**
        - [Response의 SatausCode가 400으로 네트워크 통신이 실패하였을 때 Error만 리턴하는 dataTaskPublisher를 사용하지 않고 `dataTask`를 사용해서 **HTTPResponse를 디코딩하여 NetworkAPIError로 매핑**하여 에러 케이스를 분류합니다.](https://github.com/KSK9820/SUDATalk/pull/9/commits/a2c4c7cb400d659f6c3f1b2cf2beff4216d6fb61#diff-45539c40eab836d56e05ea596d32ea6439c9a6205aded10b84ab0627566e45e5)
  - **토큰 갱신**
        - NetworkAPIError 중 토큰 만료 오류(E02, E05)가 발생할 경우, UserDefaults에 저장되어 있는 refreshToken을 사용하여, accessToken을 갱신한 후, 재통신을 수행합니다.
        - [토큰 갱신 트러블 슈팅](https://github.com/KSK9820/SUDATalk/pull/12)
- **Socket 통신**
    - `SocketEventProtocol`은 소켓의 구성 요소을 명세하는 프로토콜이고, 이를 채택 한 `SocketEvent` 객체들(DM, GroupChat)은 각 소켓에 필요한 **상세 주소**와 **처리할 이벤트들**을 명확하게 분리하여 관리합니다. 이러한 구조는 **단일 책임 원칙(SRP)** 을 충실히 준수하는 방식으로, 각 객체가 자신에게 주어진 책임을 명확히 분리하여 구현하도록 돕습니다.
    - Socket 통신 URL 구성요소의 제약 사항을 명세하는 `SocketEnvironmentConfigurable` 프로토콜을 사용했습니다.
    - 소켓 이벤트와 핸들러를 가지고 있는 `SocketEventProtocol` 을 준수하는 GrouptChat과 DM 이벤트 객체가 있고, 객체 내부의 핸들러는 `SocketEventHandler` 프로토콜의 기본 구현인 decode를 사용해서 수신된 이벤트의 결과를 `SocketIoManager`에 전달합니다.
    - SocketIOManager는 소켓 통신 설정 및 디코드를 해서 View에 전달합니다.
    - Socket 통신을 지속적으로 유지하지 않고, 화면을 나가거나(onDisappear) background 또는 inactive 상태일 때 socket 연결을 종료합니다.
    - [소켓 통신 구현](https://github.com/KSK9820/SUDATalk/pull/15, https://github.com/KSK9820/SUDATalk/pull/19)
- **Swift Concurrency + Combine**
    - 기존의 **completion handler** 기반 비동기 코드를 **async/await** 스타일로 변환하기 위해 **`withCheckedThrowingContinuation`** 을 사용했습니다.
    - 이를 통해 Combine의 **Publisher** 값을 **continuation**으로 변환할 수 있었습니다. 기존 네트워크 통신 코드에서 **sink**를 통해 이벤트를 처리하는 부분을 **`withCheckedThrowingContinuation`** 으로 바꿔 **async/await** 기반의 코드로 변환했습니다.
    - 이후, 변환된 네트워크 코드를 **`withTaskGroup`** 과 **`for await in`** 구문을 사용하여 여러 데이터를 병렬로 처리했습니다. 이로써 네트워크 병렬 처리의 가독성과 효율성을 모두 개선했습니다.
- **채팅 로직**
  ![Readme Image](https://github.com/user-attachments/assets/d5e334d1-cd47-44c9-8c2b-feeef62f49d3)
    1. 로컬 데이터베이스에 저장된 채팅 정보를 읽습니다.
    2. 저장된 채팅 정보의 마지막 채팅을 바탕으로 읽지 않은 채팅을 서버에 요청합니다.
        - 로컬 데이터베이스에 저장된 채팅 정보가 없다면 이전의 채팅 내역 전체를 서버에 요청합니다.
    3. 응답받은 데이터를 DB에 저장합니다.
    4. 소켓을 연결합니다.
        - 메세지를 송신할 때에는 REST API를 사용합니다.
        - 메세지를 수신할 때에는 Socket을 사용합니다.
    5. 화면에서 나가거나(onDisappear), background 또는 inactive 상태일 경우 socket 연결을 종료합니다.
- **영속성 관리**
    - `KeyChain`을 사용하여 암호화된 형태로 민감한 정보인 token을 저장합니다.
    - `UserDefaults`를 사용하여 민감하지 않은 workspace 또는 profile 정보를 저장합니다.
- **이미지 저장 및 처리**
  - **NSCache**를 활용한 메모리 캐싱
    - 네트워크 요청으로 불러온 이미지를 `NSCache`에 저장하여, 동일한 요청 시 네트워크 사용을 줄이고 빠르게 이미지를 조회할 수 있도록 구현했습니다.
    - 앱 실행 중 반복적인 이미지 로드를 효율적으로 처리합니다.
  - **FileManager**를 활용한 디스크 저장
    - 네트워크가 유실되었을 때에도 이미지를 조회할 수 있도록, `FileManager`를 사용하여 이미지를 디스크에 저장합니다.
    - 캐시된 이미지는 앱 재실행 후에도 유지되며, 지속성을 제공합니다.
- **NavigationLazyView를 사용하여 초기 뷰 로드 최적화**
    - NavigationLazyView를 사용해서 init 시점에 불필요한 메모리 소비를 줄이고 뷰를 사용하는 시점에 rendering을 해서 앱의 성능을 향상시킬 수 있습니다.

<br/>

## Trouble Shotting
- [토큰 갱신과 Value 값의 KeyChainManager](https://github.com/KSK9820/SUDATalk/pull/12)
- [비동기로 응답받는 시점의 문제](https://github.com/KSK9820/SUDATalk/pull/30)
- [이미지 로드시 이중 해제 문제](https://github.com/KSK9820/SUDATalk/pull/31)

<br/>

## 회고
- 이미지 처리의 최적화
    - 기존에는 메모리 캐싱과 FileManager를 사용한 디스크 저장을 사용하고 있다. 이 중 디스크 저장의 경우 이미지를 디스크에 저장하고 불러오는 과정은 디스크 캐싱의 기본적인 기능만 구현되어 있는데
        - 디스크에 저장된 데이터의 만료 시간, 최대 용량 등을 관리하는 등의 캐싱 정책
        - 오래된 데이터 삭제, 정렬 등의 저장된 이미지의 관리하고 디스크 저장 구조를 개선하는 등의 최적화
      
    → 이러한 개선을 통해 이미지를 더욱 효율적으로 처리하고, 사용자가 빠르고 안정적으로 이미지를 조회할 수 있도록 하여 **더 나은 사용자 경험**을 제공하도록 개선하고 싶다.
    
- Decoder와 네트워크
    - 처음에는 이미지와 같이 decoder가 필요하지 않는 경우가 있기 때문에 decoder를 갖고 있는 객체와 갖고 있지 않은 객체로 분리하여 필요한 기능만을 갖게끔 설계하려고 했습니다. 
    그러나 이후 서버 문서를 확인하면서, 서버에서 제공하는 에러 코드가 데이터에 포함이 되어 있기 때문에 이를 디코드하여 처리해야 한다는 요구사항을 발견했습니다. 이로 인해 결국 모든 네트워크 객체가 디코더를 갖도록 수정해야 했습니다.
    - **배운 점**
      - **서버 설계를 기반으로 한 구조 설계의 중요성**: 원하는 구조를 구현하는 것만큼 중요한 점은, **서버의 설계**와 일치하는 방식으로 클라이언트 구조를 설계하는 것입니다.
      - **유연한 설계 필요성**: 프로젝트 초기에 지나치게 이상적인 설계를 고수하기보다는, 실제 시스템의 동작 방식을 반영할 수 있도록 설계를 유연하게 변경할 필요가 있다는 점을 배웠습니다.
      
    → 이번 경험을 통해 서버와 클라이언트 간의 **상호작용**을 고려한 설계가 얼마나 중요한지, 그리고 그에 따라 구조를 수정할 수 있는 유연성을 갖추는 것이 중요하다는 교훈을 얻었습니다.

