import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:haru_admin/model/grammer_data_model.dart';
import 'package:haru_admin/api/network/dio_client.dart';
import 'package:haru_admin/utils/secure_storage.dart';

class GrammerDataRepository {
  final dio = DioClient().provideDio();
  final dioFile = DioClient().provideDioForFile();
  SecureStorage secureStorage = SecureStorage();

  getGrammerDataList() async {
    try {
      final response = await dio.get(
        '/grammer-list',
      );
      // final grammerData =
      //     response.data.map((e) => GrammerData.fromJson(e)).toList();
      return response;
    } catch (e) {
      print("error : $e");
    }
  }

  addToGrammerDataList(AddGrammerData data) async {
    try {
      final response = await dio.post('/grammer', data: data.toJson());

      return response;
    } catch (e) {
      print("error : $e");
    }
  }

  addToGrammerFile(String imageURL) async {
    try {
      final bytes = await http
          .get(Uri.parse(imageURL))
          .then((response) => response.bodyBytes);

      var formData = FormData.fromMap({
        'f': MultipartFile.fromBytes(bytes,
            filename: imageURL.split('/').last,
            contentType: MediaType('image', 'png')),
      });

      final response =
          await dio.post('/grammer/file', data: {'file': formData});

      return response;
    } catch (e) {
      print("error : $e");
    }
  }
}
