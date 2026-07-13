import SwiftUI

struct ConverterView: View {
    @State private var viewModel: ConverterViewModel

    init(branch: BankBranch) {
        _viewModel = State(initialValue: ConverterViewModel(branch: branch))
    }

    var body: some View {
        Form {
            if viewModel.isSelectedCurrencyAvailable {
                calculatorForm
            } else {
                unavailableCurrencyForm
            }
        }
        .navigationTitle("Калькулятор валют")
    }

    private var calculatorForm: some View {
        Group {
            Picker("Режим", selection: $viewModel.direction) {
                Text("Купить \(viewModel.selectedCurrency.rawValue)").tag(ExchangeDirection.buy)
                Text("Продать \(viewModel.selectedCurrency.rawValue)").tag(ExchangeDirection.sell)
            }
            .pickerStyle(.segmented)

            Picker("Валюта", selection: $viewModel.selectedCurrency) {
                ForEach(viewModel.availableCurrencies) { currency in
                    Text(currency.rawValue).tag(currency)
                }
            }

            TextField(viewModel.amountPlaceholder, text: $viewModel.amount)
                .keyboardType(.decimalPad)
                .keyboardDoneButton()

            Section("Результат") {
                HStack {
                    Spacer()
                    VStack(spacing: 4) {
                        Text(viewModel.calculatedResult, format: .number.precision(.fractionLength(2)))
                            .font(.system(size: 32, weight: .bold))
                        Text(viewModel.resultCurrencyLabel)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
            }

            Section("Курс") {
                VStack(alignment: .leading, spacing: 4) {
                    Text("1 \(viewModel.selectedCurrency.rawValue) = \(viewModel.rateForOneUnit, format: .number.precision(.fractionLength(4))) BYN")
                        .font(.headline)

                    if viewModel.selectedCurrency.denomination != 1 {
                        Text("\(Int(viewModel.selectedCurrency.denomination)) \(viewModel.selectedCurrency.rawValue) = \(viewModel.apiRate, format: .number.precision(.fractionLength(4))) BYN")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    private var unavailableCurrencyForm: some View {
        Section {
            Picker("Валюта", selection: $viewModel.selectedCurrency) {
                ForEach(Currency.calculator) { currency in
                    Text(currency.rawValue).tag(currency)
                }
            }

            ContentUnavailableView(
                "Валюта недоступна",
                systemImage: "xmark.circle",
                description: Text("Эта валюта недоступна в выбранном отделении")
            )
        }
    }
}
