# Change Log

## 0.8 — 國中生四單元生活理財改版

- 使用者將遊戲對象改為國中生，並指定新的四段遊戲流程；需求版本升至 0.3。
- 以滑桿配置需要、想要、儲蓄與投資；範圍允許多種有效答案，投資明示可能虧損且不保證獲利。
- 新增早餐店、便利商店、傳統雜貨店共九項購物分類；每次結帳後顯示分類理由。
- 新增六題「立刻買／想一想／先存錢」情境與突發支出決策；單元完成才取得星鑰。
- 分數改為四單元各 100 分、錯誤選擇扣 10 分，結尾顯示 /400 總分及 4/4 學習進度。
- 更新專案簡介、追蹤矩陣、快速開始和專案狀態。提交 `faed467` 已由 GitHub Actions 匯出並部署；瀏覽器確認新 HUD 載入，完整互動流程仍待手動遊玩驗證。

## 0.7 — 視覺方向 B 與 GitHub Pages 部署

- 使用者確認 B「紙雕故事書」為正式視覺方向；將遊戲畫面調整為鼠尾草綠、紙卡其、磚橘與分層紙板風格。
- 新增 Godot Web 匯出預設與 GitHub Actions Pages 自動建置／部署流程；儲存庫已改用 GitHub Actions 作為 Pages 發布來源。
- 加入 Noto Sans TC（SIL OFL 1.1）與授權清冊，修正瀏覽器匯出缺少中文字型的問題；啟用 CJK 文字 shaping 資料。
- GitHub Pages 建置及部署流程加入提交版本目錄，根網址自動轉至最新版本，避免瀏覽器沿用舊匯出檔快取。
- Godot 4.7.2 網頁匯出與 GitHub Pages 部署成功；目視確認公開頁面能顯示場景 B 與繁體中文。

## 0.6 — 技能套用稽核與文件校正

- 新增 `skill-compliance.md`，分別記錄 DT-SDLC、game-design 與 Blender Toolkit 的實際套用範圍。
- 修正設計競賽、專案簡報及測試表中落後於初版的狀態；確認遊戲視窗中已看見 Blender GLB 預覽。
- 保留視覺選擇與最終驗收為待辦；不把原型使用的臨時畫風當成正式批准。

## 0.5 — 發布至 GitHub

- 將可玩初版、Blender 場景與 GLB、Godot 專案、啟動器及設計文件推送至 `kellyku1025-stack/game2` 的 `main` 分支。
- 初版程式提交：`e1b9332`；Git author 明確標示為 OpenAI Codex。
- 更新發布狀態與需求追蹤；正式視覺選擇、玩家測試及最終驗收仍待完成。

## 0.4 — 可玩初版

- 確認 `Game2` 工作區為版本來源，並已將可玩初版同步至使用者指定的 `C:\Godot` 專案資料夾。
- 以原創貨艙場景實作已選玩法 D：先存再花配置與三商店分散投資配置；各關需通過條件才取得星鑰。
- 加入 A/D、方向鍵與滑鼠場景移動、貨箱裝箱／取回、每關得分、錯誤提示與扣分、結尾成果及重新開始。
- 改用 Godot GLTF API 載入 Blender GLB，避免首開依賴 Godot 匯入快取。
- Godot 4.7.2 視窗實際走完兩關成功流程、錯誤提示／扣分、結尾與重啟；正式視覺方向仍待使用者選擇。
- 增加 `啟動遊戲.bat` 與快速開始說明。

## 0.3 — 玩法方向已選定

- 使用者在玩法關卡選定 D「貨艙星箱配置」。
- 開始準備三種相同狀態的視覺方案；尚未選定視覺前不修改正式遊戲內容。

## 0.2 — Skills compliance recovery

- Recorded the confirmed brief, teaching mode, learning-first/appropriate-challenge profile, assumptions, test plan, and open approvals.
- Added an evidence-labelled, six-concept gameplay tournament with three design generations and separate G/P/D and R_edu scoring.
- Added DT brief, decision log, change log, and requirement traceability artifacts.
- Added the Blender-generated GLB to the source repository and ignored Godot's generated `.godot/` cache.
- Fixed camera initialization order in the 3D prop viewport; Godot headless scene startup now completes without errors.
- Kept the current build as a draft; no design selection or visual approval is recorded.
