import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 创建一个自定义的文本字段组件
class CustomTextField extends StatelessWidget {
  // 用于控制和获取 TextField 的值
  final TextEditingController controller;
  // 标签文本，当 TextField 获得焦点时显示在 TextField 上方
  final String labelText;
  // 提示文本，当 TextField 没有焦点且没有输入时显示
  final String hintText;
  // 是否隐藏文本，用于密码字段等需要隐藏输入内容的场景
  final bool obscureText;
  // 字段验证器，用于实现字段的验证逻辑，如邮箱格式，密码长度等验证
  final FormFieldValidator<String>? validator;

  // 构造函数，定义了该组件需要的参数
  CustomTextField({
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.obscureText = false,
    this.validator,
  });

  // build 方法，定义了该组件的视觉展示方式
  @override
  Widget build(BuildContext context) {
    // 返回一个 TextFormField 组件
    return TextFormField(
      // 用于获取和控制字段的值
      controller: controller,
      // 定义字段的装饰，如边框、标签文本、提示文本等
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
        hintText: hintText,
      ),
      // 定义是否隐藏字段的文本
      obscureText: obscureText,
      // 用于字段的验证逻辑
      validator: validator,
    );
  }
}
