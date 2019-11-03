import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';

class YuvConverter{
  static Uint8List yuv420ToGrayBinary(Size imageSize, List<Plane> planes, Rect rect) {
    var maxSize = rect.bottom - rect.top;
    var minSize = rect.right - rect.left;
    var top = rect.top;
    var left = rect.left + (maxSize-minSize);
//    left+=10;
    print('${maxSize.toString()}, ${minSize.toString()}');

    var _inputSize = 48;
    var compRatio = maxSize~/_inputSize;
    var complement = maxSize%_inputSize;
    top -= complement;
    left-=complement;

    //   Convert to grayScale image binary
    final Plane yChannel = planes[0];
    final binary = yChannel.bytes;
    var convertedBytes = Float32List(1 * _inputSize * _inputSize * 1);
    var buffer = Float32List.view(convertedBytes.buffer);
    int rowSize = imageSize.height.toInt();
    int pixelIndex = 0;

    for (var y = 0; y < _inputSize; y++) {
      for (var x = 0; x < _inputSize; x++) {
        // image Rotation 0[degree]
//        var pixel = (top+y*compRatio*rowSize+left+x*compRatio).toInt();
        // image Rotation 90[degree]
        var pixel = ((left-1)*rowSize+(rowSize-top)+x*compRatio*rowSize-y*compRatio).toInt();

        try {
          buffer[pixelIndex] = binary[pixel] / (255);
        }catch(e){
          buffer[pixelIndex] = 1.0;
        }
        pixelIndex++;
      }
    }
//    return convertedBytes;
    return convertedBytes.buffer.asUint8List();
  }
}
