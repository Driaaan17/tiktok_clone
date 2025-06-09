// lib/screens/home/pages/upload/upload_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:typed_data';
import '../../../../providers/auth_provider.dart';
import '../../../../services/video_service.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _hashtagsController = TextEditingController();

  // For mobile platforms
  File? _selectedVideo;
  File? _selectedThumbnail;
  
  // For web platform
  Uint8List? _selectedVideoBytes;
  String? _selectedVideoName;

  String? _selectedCategory = '1';
  bool _isUploading = false;

  final List<Map<String, dynamic>> _categories = [
    {'id': '1', 'name': 'Menyanyi & Menari'},
    {'id': '2', 'name': 'Komedi'},
    {'id': '3', 'name': 'Olahraga'},
    {'id': '4', 'name': 'Anime & Komik'},
    {'id': '5', 'name': 'Hubungan'},
    {'id': '6', 'name': 'Pertunjukan'},
    {'id': '7', 'name': 'Lipsync'},
    {'id': '8', 'name': 'Kehidupan Sehari-hari'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(child: _buildMainContent()),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildUploadButton(),
          _buildMenuSection(),
          _buildToolsSection(),
          _buildOtherSection(),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.music_note,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'TikTok Studio',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ElevatedButton(
        onPressed: _isUploading ? null : _selectVideo,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF6B9D),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: _isUploading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : const Text(
                '+ Unggah',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  Widget _buildMenuSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            'KELOLA',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _buildMenuItem(Icons.home_outlined, 'Beranda', false),
        _buildMenuItem(Icons.video_library_outlined, 'Postingan', false),
        _buildMenuItem(Icons.analytics_outlined, 'Analisis', false),
        _buildMenuItem(Icons.comment_outlined, 'Komentar', false),
      ],
    );
  }

  Widget _buildToolsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            'ALAT',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _buildMenuItem(Icons.lightbulb_outline, 'Inspirasi', false, hasNotification: true),
        _buildMenuItem(Icons.school_outlined, 'Akademi Kreator', false),
        _buildMenuItem(Icons.volume_up_outlined, 'Suara Tak Terbatas', false),
      ],
    );
  }

  Widget _buildOtherSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            'LAINNYA',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _buildMenuItem(Icons.feedback_outlined, 'Umpan balik', false),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, bool isSelected, {bool hasNotification = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        leading: Stack(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.black : Colors.grey[600],
              size: 22,
            ),
            if (hasNotification)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.grey[600],
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      color: const Color(0xFFF8F8F8),
      child: Column(
        children: [
          _buildTopHeader(),
          Expanded(child: _buildUploadArea()),
        ],
      ),
    );
  }

  Widget _buildTopHeader() {
    return Container(
      height: 60,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.pink[100],
            child: Text(
              'A',
              style: TextStyle(
                color: Colors.pink[400],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          if (_hasVideo())
            ElevatedButton(
              onPressed: _isUploading ? null : _showUploadForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF3040),
                foregroundColor: Colors.white,
              ),
              child: const Text('Lanjutkan'),
            ),
        ],
      ),
    );
  }

  Widget _buildUploadArea() {
    if (_hasVideo()) {
      return _buildVideoSelected();
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildUploadIcon(),
          const SizedBox(height: 24),
          _buildUploadText(),
          const SizedBox(height: 32),
          _buildSelectVideoButton(),
          const SizedBox(height: 60),
          _buildUploadSpecs(),
        ],
      ),
    );
  }

  Widget _buildVideoSelected() {
    final videoName = kIsWeb ? _selectedVideoName : _selectedVideo?.path.split('/').last;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.play_circle_fill, size: 60, color: Colors.white),
                const SizedBox(height: 8),
                const Text('Video Dipilih', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                if (videoName != null)
                  Text(
                    videoName,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: _clearVideo,
                child: const Text('Ganti Video'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _showUploadForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF3040),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Lanjutkan'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadIcon() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.file_upload_outlined,
        size: 60,
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildUploadText() {
    return Column(
      children: [
        const Text(
          'Pilih video untuk diunggah',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Atau tarik dan letakkan di sini',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectVideoButton() {
    return ElevatedButton(
      onPressed: _selectVideo,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF3040),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: const Text(
        'Pilih video',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildUploadSpecs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSpecItem(
          Icons.schedule,
          'Ukuran dan durasi',
          'Ukuran maksimum: 50 MB, durasi video: 60 menit.',
        ),
        const SizedBox(width: 60),
        _buildSpecItem(
          Icons.folder,
          'Format file',
          'Rekomendasi: ".mp4". Mendukung format utama lainnya.',
        ),
        const SizedBox(width: 60),
        _buildSpecItem(
          Icons.high_quality,
          'Resolusi video',
          'Resolusi tinggi yang direkomendasikan: 1080p, 1440p, 4K.',
        ),
        const SizedBox(width: 60),
        _buildSpecItem(
          Icons.aspect_ratio,
          'Rasio aspek',
          'Rekomendasi: 16:9 untuk lanskap, 9:16 untuk vertikal.',
        ),
      ],
    );
  }

  Widget _buildSpecItem(IconData icon, String title, String description) {
    return SizedBox(
      width: 200,
      child: Column(
        children: [
          Icon(icon, color: Colors.grey[700], size: 32),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  bool _hasVideo() {
    return kIsWeb ? _selectedVideoBytes != null : _selectedVideo != null;
  }

  void _clearVideo() {
    setState(() {
      _selectedVideo = null;
      _selectedVideoBytes = null;
      _selectedVideoName = null;
    });
  }

  Future<void> _selectVideo() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
        withData: kIsWeb,
      );

      if (result != null) {
        final file = result.files.single;

        if (file.size > 50 * 1024 * 1024) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Video selected: ${file.name}'),
              backgroundColor: Colors.green,
            ),
          );
          return;
        }

        if (kIsWeb) {
          setState(() {
            _selectedVideoBytes = file.bytes!;
            _selectedVideoName = file.name;
          });
        } else {
          setState(() {
            _selectedVideo = File(file.path!);
          });
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Video selected: ${file.name}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting video: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showUploadForm() {
    showDialog(
      context: context,
      builder: (context) => _buildUploadDialog(),
    );
  }

  Widget _buildUploadDialog() {
    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Upload Video',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              maxLength: 100,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              maxLength: 500,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category['id'],
                  child: Text(category['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _hashtagsController,
              decoration: const InputDecoration(
                labelText: 'Hashtags',
                hintText: '#trending #viral #fun',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _isUploading ? null : _uploadVideo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF3040),
                    foregroundColor: Colors.white,
                  ),
                  child: _isUploading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Upload'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadVideo() async {
    if (!_hasVideo()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a video'), backgroundColor: Colors.red),
      );
      return;
    }

    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a title'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (!authProvider.isAuthenticated) {
        throw Exception('Please login to upload videos');
      }

      List<String> hashtags = _hashtagsController.text
          .split(' ')
          .where((tag) => tag.trim().isNotEmpty)
          .map((tag) => tag.trim().replaceAll('#', ''))
          .toList();

      File videoFile;

      if (kIsWeb) {
        // For web, pass bytes directly to VideoService
        final success = await VideoService.uploadVideoBytes(
          videoBytes: _selectedVideoBytes!,
          fileName: _selectedVideoName!,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          categoryId: int.parse(_selectedCategory!),
          hashtags: hashtags,
        );
        
        if (!mounted) return;
        
        if (success) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Video uploaded successfully!'), backgroundColor: Colors.green),
          );
          _clearVideo();
          _titleController.clear();
          _descriptionController.clear();
          _hashtagsController.clear();
        } else {
          throw Exception('Upload failed');
        }
        return;
      } else {
        videoFile = _selectedVideo!;
      }

      final success = await VideoService.uploadVideo(
        videoFile: videoFile,
        thumbnailFile: null,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        categoryId: int.parse(_selectedCategory!),
        hashtags: hashtags,
      );

      if (kIsWeb) {
        await videoFile.delete();
      }

      if (!mounted) return;

      if (success) {
        Navigator.pop(context); // Close dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Video uploaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        _clearVideo();
        _titleController.clear();
        _descriptionController.clear();
        _hashtagsController.clear();
      } else {
        throw Exception('Upload failed');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload failed: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _hashtagsController.dispose();
    super.dispose();
  }
}