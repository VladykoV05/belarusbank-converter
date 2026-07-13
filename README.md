# BelarusBank Converter

iOS-приложение для просмотра курсов валют и конвертации по данным [Беларусбанка](https://belarusbank.by).

## Возможности

- Список отделений с поиском и фильтрацией
- Избранные отделения (SwiftData)
- Курсы покупки/продажи по валютам
- Калькулятор обмена (`ExchangeCalculator`) с учётом номиналов
- Оффлайн-кэш на 24 часа

## Архитектура

Проект построен по **MVVM** с разделением на слои:

```
Converter/
├── App/                    # Точка входа, DI-контейнер
├── Core/
│   ├── Models/             # BankBranch, Currency, FavoriteBranch
│   ├── Networking/         # API-клиент (URLSession + async/await)
│   ├── Persistence/        # Кэш (UserDefaults), избранное (SwiftData)
│   ├── Repositories/       # BranchRepository — оркестрация API + кэш
│   ├── Services/           # NetworkMonitor, CurrencyConverter
│   ├── Constants/
│   ├── Extensions/
│   └── Errors/
├── Features/
│   ├── Root/               # ContentView — навигация
│   ├── BranchSelection/    # View + ViewModel
│   ├── BranchDetails/      # TabView отделения
│   ├── Rates/              # View — список курсов
│   └── ExchangeCalculator/ # View + ViewModel — калькулятор обмена
└── Shared/
    └── Components/         # SearchBar, ErrorView, OfflineBanner
```

### Роли и папки

| Роль | Папка | Ответственность |
|---|---|---|
| **App** | `App/` | Запуск, DI-контейнер |
| **View** | `Features/`, `Shared/` | UI без бизнес-логики |
| **ViewModel** | `Features/` | Состояние экрана (`ExchangeCalculatorViewModel` и др.) |
| **Model** | `Core/Models/` | Структуры данных |
| **Repository** | `Core/Repositories/`, `Core/Persistence/` | API, кэш, SwiftData |
| **Networking** | `Core/Networking/` | HTTP-запросы |
| **Service** | `Core/Services/` | Бизнес-логика (`CurrencyConverter`) |

### DI (Dependency Injection)

`AppDependencies` создаётся в `@main` и передаётся через `Environment`:

```swift
ContentView()
    .environment(\.appDependencies, dependencies)
```

ViewModels получают репозитории через инициализатор — без синглтонов.

## Стек

- SwiftUI + Observation (`@Observable`)
- SwiftData
- URLSession (async/await)
- Network framework

## Запуск

**Требования:** Xcode 16+, iOS 18.2+

```bash
git clone https://github.com/<username>/Converter.git
cd Converter
open Converter.xcodeproj
```

## API

```
GET https://belarusbank.by/api/kursExchange
```

## Автор

Иван Владько — портфолио-проект для демонстрации навыков iOS-разработки.
