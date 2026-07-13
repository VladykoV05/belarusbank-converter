# BelarusBank Converter

iOS-приложение для просмотра курсов валют и конвертации по данным [Беларусбанка](https://belarusbank.by).

## Возможности

- Список отделений с поиском и фильтрацией
- Избранные отделения (SwiftData)
- Курсы покупки/продажи по валютам
- Калькулятор обмена с учётом номиналов
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
│   ├── Root/               # ContentView
│   ├── BranchSelection/    # View + ViewModel
│   ├── BranchDetails/
│   ├── Rates/
│   └── Converter/          # View + ViewModel
└── Shared/
    └── Components/         # SearchBar, ErrorView, OfflineBanner
```

### Принципы

| Слой | Ответственность |
|---|---|
| **View** | Только UI, без бизнес-логики |
| **ViewModel** | Состояние экрана, фильтрация, вызов репозиториев |
| **Repository** | Источник данных: API + кэш |
| **Service** | Чистая бизнес-логика (конвертация валют) |
| **Protocol** | Зависимости через протоколы — удобно для тестов |

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
