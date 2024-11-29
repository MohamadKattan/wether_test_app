enum ResultsLevel { success, fail, notSupported }

class ResultController<T> {
  final T? data;
  final String? error;
  final String? msg;
  final ResultsLevel? status;
  ResultController({this.data, this.error, this.status, this.msg});

  factory ResultController.fromMap(Map<String, dynamic> map) {
    return ResultController(
      data: map['data'],
      msg: map['msg'],
      error: map['error'],
    );
  }
}
