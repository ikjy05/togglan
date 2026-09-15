# Togglan

메뉴바에서 랜선(이더넷) 연결을 켜고 끄는 간단한 macOS 앱.

- `USB 10/100/1000 LAN` 같은 이더넷 서비스를 자동 감지 (Wi-Fi, Thunderbolt Bridge, iPhone/iPad USB 등은 제외)
- 메뉴바 아이콘 클릭 → 현재 상태 확인 및 토글
- 이더넷 인터페이스가 여러 개면 "인터페이스 선택" 서브메뉴에서 전환 가능
- 내부적으로 `networksetup -setnetworkserviceenabled`를 호출 (sudo 불필요)

## 빌드

```bash
./build.sh
```

`Togglan.app`이 프로젝트 루트에 생성됩니다.

## 실행

```bash
open Togglan.app
```

## Applications 폴더에 설치 (선택)

```bash
cp -R Togglan.app /Applications/
```

## 로그인 시 자동 실행 (선택)

시스템 설정 > 일반 > 로그인 항목에서 `Togglan.app`을 추가하면 로그인할 때마다 자동으로 실행됩니다.
