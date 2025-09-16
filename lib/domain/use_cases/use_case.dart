/// Abstract base class for Use Cases.
///
/// Defines a standardized contract for executing business logic.
/// This ensures that all use cases in the application have a predictable
/// and consistent structure.
///
/// [Type] is the data type that the use case will return.
/// [Params] is the data type of the parameters that the use case needs to execute.
/// If a use case does not require parameters, you can use [void].
abstract class UseCase<Type, Params> {
  /// Executes the use case with the provided parameters.
  Future<Type> call(Params params);
}
