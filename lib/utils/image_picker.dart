import 'package:image_picker/image_picker.dart';

Future<String?> pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return _file.path;
  }
}
