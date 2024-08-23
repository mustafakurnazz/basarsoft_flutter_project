
import 'package:flutter/material.dart';

class FormContainer extends StatefulWidget{
  final TextEditingController? controller;
  final String? hintText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final bool obsurcetext;

  const FormContainer({
    this.controller,
    this.hintText,
    this.onSaved,
    this.validator,
    this.obsurcetext = false,
  });

  @override
  FormContainerWidgetState createState() => new FormContainerWidgetState(); 
}

class FormContainerWidgetState extends State<FormContainer> {
    
    @override
    Widget build(BuildContext context) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(.35),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          style: const TextStyle(color: Colors.blue),
          controller: widget.controller,
          onSaved: widget.onSaved,
          validator: widget.validator,
          obscureText: widget.obsurcetext,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Colors.black45),
          ),
        ),
      );
    }
}