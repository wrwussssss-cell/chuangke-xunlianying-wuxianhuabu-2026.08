# 后端 HTTP 接口清单（main.py 全量路由）

> 共 **130+ 路由**。行号为 `main.py` 中的装饰器行号，可按行号跳转。
> 标注【任务】的接口为"提交后轮询"的异步任务模式。

## 1. 页面与文件服务

| 方法 | 路径 | 行号 | 说明 |
|---|---|---|---|
| GET | `/` | 11532 | 首页（index.html） |
| GET | `/api/view` | 11536 | 代理 ComfyUI 的 `/view`（输入/输出文件直读） |
| GET | `/api/download-output` | 11559 | 下载 output 产物（支持 inline） |
| GET | `/api/media-preview` | 6820 | 媒体缩略图（webp，含视频抽帧），缓存到 data/media_previews |
| GET | `/api/image-jpeg` | 6859 | 图片转 JPEG（透明处理） |
| WS | `/ws/stats` | 201 | WebSocket：队列/状态广播（按 client_id） |

## 2. 版本 / 更新 / 应用信息

| 方法 | 路径 | 行号 | 说明 |
|---|---|---|---|
| GET | `/api/app-info` | 1738 | 版本、目录、运行环境信息 |
| GET | `/api/update-connectivity/probe` · `/api/update-connectivity` | 1809/1820 | 更新源连通性探测 |
| GET | `/api/check-update` | 1883 | 检查新版本（GitHub + ModelScope） |
| POST | `/api/update-from-github` | 2197 | 执行自更新（staging→替换→备份→重启） |
| GET | `/api/update-backups` | 2360 | 更新备份列表 |
| POST | `/api/update-rollback` | 2369 | 回滚到备份 |

## 3. 配置与 Provider（渠道）

| 方法 | 路径 | 行号 | 说明 |
|---|---|---|---|
| GET | `/api/config` | 12971 | 前端启动配置（Key 脱敏后的 providers 等） |
| GET | `/api/config/token` | 13060 | 全局 token |
| GET | `/api/models` | 12989 | 模型清单汇总 |
| GET/PUT | `/api/providers` | 12993/12997 | 渠道列表读取 / 整体保存 |
| POST | `/api/providers/test-connection` | 13306 | 验证渠道地址（按协议探测） |
| POST | `/api/providers/probe-async` | 13419 | 异步生图端点探测 |
| POST/GET | `/api/providers/fetch-models`、`/api/providers/{id}/fetch-models` | 13695/13702 | 从上游拉模型列表并分类 |
| GET/PUT | `/api/comfyui/instances` | 18728/18732 | ComfyUI 实例列表读写 |
| GET/PATCH | `/api/storage-settings` | 6698/6706 | 存储目录设置 |
| GET | `/api/storage-files` · `/api/storage-files/{kind}/{path}` | 6710/6740 | 存储文件浏览 |
| POST | `/api/storage-files/delete` | 6747 | 批量删除存储文件（联动清理历史/画布引用） |

## 4. 生图（API / ModelScope / Angle）

| 方法 | 路径 | 行号 | 说明 |
|---|---|---|---|
| POST | `/api/online-image` | 13787 | 在线生图（同步，走 generate_ai_image 总调度 main.py:11005） |
| POST | `/api/image-task-query` | 13791 | 按任务 ID 查询异步生图结果（通用轮询） |
| POST | `/api/canvas-image-tasks` | 13960 | 【任务】画布生图任务提交 |
| GET | `/api/canvas-image-tasks/{task_id}` | 13978 | 画布生图任务轮询 |
| POST | `/api/ms/generate` | 17942 | ModelScope 生图（老接口，画布 msgen 节点用） |
| POST | `/api/angle/generate` | 17759 | Angle 视角重塑生成 |
| POST | `/api/angle/poll_status` | 17688 | Angle 任务轮询 |
| GET | `/api/image-params` | 14091 | 按渠道+模型返回参数表单定义（前端动态渲染） |

## 5. 生视频

| 方法 | 路径 | 行号 | 说明 |
|---|---|---|---|
| POST | `/api/canvas-video` | 15045 | 统一视频生成入口（APIMart/Veo3.1、Agnes、Yuli、灵境、Grok、土豆、火山、RunningHub、即梦） |
| POST | `/api/temp-sh/upload` | 12343 | 本地视频传 temp.sh 换公网链接 |
| POST | `/api/cloud-video/upload` | 12348 | 本地视频传 litterbox 换公网链接 |
| POST | `/api/jimeng/query-media` | 12952 | 即梦媒体结果查询 |

## 6. ComfyUI 工作流

| 方法 | 路径 | 行号 | 说明 |
|---|---|---|---|
| POST | `/generate` | 17853 | ComfyUI 工作流执行（核心，main.py:18049；多实例调度+参数注入） |
| GET | `/api/workflows` | 18768 | 工作流列表（workflows/ 目录 + 内置） |
| GET | `/api/workflows/{name}` | 18799 | 读工作流 JSON |
| POST | `/api/workflows` | 18818 | 上传工作流 |
| PUT | `/api/workflows/{name}/config` | 18839 | 保存工作流参数配置 |
| DELETE | `/api/workflows/{name}` | 18851 | 删除工作流 |
| POST | `/api/workflows/{name}/run` | 18866 | 运行工作流 |
| POST | `/api/canvas-comfy-tasks` | 14013 | 【任务】画布 Comfy 任务提交 |
| GET | `/api/canvas-comfy-tasks/{task_id}` | 14030 | 画布 Comfy 任务轮询 |
| POST | `/api/comfyui/upload-base64` | 11708 | base64 上传图片到 ComfyUI 输入 |

## 7. RunningHub

| 方法 | 路径 | 行号 | 说明 |
|---|---|---|---|
| GET | `/api/runninghub/app-info` | 12363 | webapp 信息 |
| POST | `/api/runninghub/submit` | 12386 | 提交 webapp 任务 |
| POST | `/api/runninghub/workflow-submit` | 12417 | 提交工作流任务 |
| GET | `/api/runninghub/workflow-info` | 12453 | 工作流任务信息 |
| GET/POST/PUT/DELETE | `/api/runninghub/workflows...` | 12485–12598 | 工作流列表/读取/抓取/保存/删除（本地 store + provider 同步） |
| GET | `/api/runninghub/query` | 12613 | 任务查询 |
| POST | `/api/runninghub/upload-asset` | 12652 | 上传资产到 RunningHub |

## 8. 本地 CLI 集成（即梦 / Codex / Gemini CLI）

| 方法 | 路径 | 行号 | 说明 |
|---|---|---|---|
| GET | `/api/jimeng/status` · `/api/jimeng/credit` | 12830/12859 | 即梦 CLI 状态 / 积分 |
| POST | `/api/jimeng/login/start` · GET `/api/jimeng/login/status` | 12869/12917 | 扫码登录（二维码） |
| POST | `/api/jimeng/logout` · `/api/jimeng/help` | 12864/12939 | 登出 / CLI 帮助 |
| GET | `/api/codex/status` · POST `/api/codex/help` | 12694/12738 | Codex CLI 状态/帮助 |
| GET | `/api/gemini-cli/status` · POST `/api/gemini-cli/help` | 12763/12804 | Gemini CLI 状态/帮助 |

## 9. 聊天 / LLM / 会话

| 方法 | 路径 | 行号 | 说明 |
|---|---|---|---|
| POST | `/api/chat` | 17084 | 非流式聊天（含附件、画图意图） |
| POST | `/api/chat/stream` | 17464 | SSE 流式聊天 |
| POST | `/api/chat/agent` | 17213 | 智能体模式（自动决策画图/回答） |
| POST | `/api/chat/agent/stream` | 17299 | 智能体模式 SSE 流式 |
| POST | `/api/canvas-llm` | 15541 | 画布 LLM 节点调用 |
| GET/POST | `/api/conversations`、`/{id}` | 15634–15649 | 会话列表/创建/读取/删除（X-User-Id 隔离） |

## 10. 画布 / 项目

| 方法 | 路径 | 行号 | 说明 |
|---|---|---|---|
| GET | `/api/canvases` · `/api/canvases/trash` | 15659/15714 | 画布列表 / 回收站 |
| POST | `/api/canvases` | 15718 | 新建画布 |
| GET | `/api/canvases/{id}` · `/meta` · POST `/meta` | 15763/15722/15733 | 读取 / 元信息读 / 元信息改（title/color/icon/pinned/project/board 位置） |
| POST | `/api/canvases/{id}/touch` | 15767 | 更新活跃时间 |
| PUT | `/api/canvases/{id}` | 16925 | **保存画布**（节点/连线/日志全量） |
| POST | `/api/canvases/{id}/logs/delete` | 16967 | 删除画布日志记录 |
| DELETE | `/api/canvases/{id}` | 17045 | 移入回收站 |
| POST | `/api/canvases/{id}/restore` · `/purge` | 17057/17070 | 恢复 / 彻底删除 |
| GET/POST/PUT/DELETE | `/api/projects...` | 15663–15685 | 项目 CRUD |
| GET | `/api/canvas-assets` | 15778 | 全部画布资产索引 |
| POST | `/api/canvas-assets/check` · `/download` | 15794/15807 | 检查外部资源可用性 / 批量落地到本地 |
| POST | `/api/canvas-workflows/export` · `/export-to-library` · `/import` | 15944/15954/15993 | 画布导出 zip（含资源）/ 存素材库 / 导入 |
| POST | `/api/smart-canvas/group-export` | 16070 | 智能画布分组导出 |
| GET | `/api/smart-canvas/prompt-templates` | 15784 | 内置提示词模板（解析 system-prompts md） |

## 11. 素材库 / 提示词库 / URL 库 / 共享文件夹

| 方法 | 路径 | 行号 | 说明 |
|---|---|---|---|
| GET | `/api/asset-library` | 16118 | 素材库全量索引 |
| POST/PUT/PATCH/DELETE | `/api/asset-library/libraries|categories|items...` | 16356–16870 | 多库/分类/条目 CRUD、批量添加/删除/移动、裁剪（crop）、重命名 |
| POST | `/api/asset-library/items/classify` | 16674 | AI 视觉模型批量打标 |
| POST | `/api/asset-library/workflows/upload` | 15970 | 上传工作流到素材库 |
| POST | `/api/asset-library/items/{id}/register-avatar` · `avatar-status` | 16707/16761 | 注册数字人资产（APIMart/火山）+ 状态轮询 |
| GET/PATCH | `/api/asset-classification-prompt` | 6765/6774 | AI 打标提示词读写 |
| GET/POST/PATCH/DELETE | `/api/asset-url-library/items...` | 16122–16163 | URL 公网素材库 CRUD |
| GET/POST/PATCH/DELETE | `/api/prompt-libraries...` | 16173–16335 | 提示词库/分类/条目 CRUD、批量删除 |
| GET/POST/DELETE | `/api/shared-folders...` | 16489–16526 | 共享文件夹注册/列表/注销 |
| GET | `/api/shared-folders/{id}/tree` · `/file` | 16537/16548 | 目录树 / 文件读取 |
| POST | `/api/shared-folders/import` | 16562 | 从共享文件夹导入素材 |

## 12. 本地素材（uploads）

| 方法 | 路径 | 行号 | 说明 |
|---|---|---|---|
| POST | `/api/local-assets/upload` | 12012 | 上传本地素材（多文件+文件夹） |
| POST | `/api/local-assets/import-urls` | 12039 | URL 批量导入 |
| GET | `/api/local-assets` | 12114 | 树+条目列表 |
| POST/PATCH | `/api/local-assets/folders`、`/items` | 12119–12152 | 建文件夹 / 重命名 |
| POST | `/api/local-assets/delete` · `/move` | 12183/12209 | 删除 / 移动 |
| POST | `/api/local-assets/caption` · PATCH 同路径 · `/classify` | 12254/12329/12293 | AI 打标 / 保存打标 / 分类 |
| POST | `/api/ai/upload` · `/api/ai/upload-base64` · `/api/ai/import-local-image` | 11632/11681/12353 | AI 参考图上传（画布生成引用） |
| POST | `/api/upload` | 11604 | ComfyUI 输入上传 |

## 13. 历史 / 队列

| 方法 | 路径 | 行号 | 说明 |
|---|---|---|---|
| GET | `/api/history?type=` | 17614 | 历史记录（可按 type 过滤） |
| POST | `/api/history/delete` | 17645 | 删除历史条目 |
| GET | `/api/queue_status` | 17637 | ComfyUI 队列状态（配合 /ws/stats） |

## 14. 其他

| 方法 | 路径 | 行号 | 说明 |
|---|---|---|---|
| POST | `/api/generate`（等同 `/generate`） | 18048 | ComfyUI 执行别名入口 |

> 前端实际调用频次最高的接口：`/api/canvases/*`（自动保存）、`/api/media-preview`（缩略图）、`/api/queue_status`、`/api/canvas-image-tasks`（生图轮询）、`/api/ai/upload`（参考图）。
