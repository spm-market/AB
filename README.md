# AB
简易的AB开关SDK

# 使用
```Swift
import AB

ABManager.shared.identifier = "xptv"

// 加载数据
ABManager.shared.loadData()

// 获取数据
ABManager.shared.boolForKey("is_toggle_on")

```
