class VideoFile {
  final String path;
  final String fileName;

  VideoFile(this.path) : fileName = path.split('/').last;
}
