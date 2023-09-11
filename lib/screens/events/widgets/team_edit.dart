import 'package:casualbear_backoffice/network/models/user.dart';
import 'package:casualbear_backoffice/screens/events/cubit/team_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class TeamEdit extends StatefulWidget {
  User user; // Pass the team member data to edit.

  TeamEdit({super.key, required this.user});

  @override
  State<TeamEdit> createState() => _TeamEditState();
}

class _TeamEditState extends State<TeamEdit> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController biController = TextEditingController();
  TextEditingController codigoPostalController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  TextEditingController numClienteNOSController = TextEditingController();
  TextEditingController dataNascimentoController = TextEditingController();
  TextEditingController moradaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String? selectedTShirtSize;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    nomeController.text = widget.user.name;
    biController.text = widget.user.cc;
    codigoPostalController.text = widget.user.postalCode;
    telefoneController.text = widget.user.phone;
    moradaController.text = widget.user.address;
    emailController.text = widget.user.email;
    dataNascimentoController.text = widget.user.dateOfBirth.toString();
    numClienteNOSController.text = widget.user.nosCard;
    selectedTShirtSize = widget.user.tShirtSize;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit ${widget.user.name}'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          return null;
                        },
                        controller: nomeController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Color(0xfffafafa),
                            labelText: 'Nome Completo'),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          return null;
                        },
                        controller: biController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Color(0xfffafafa),
                            labelText: 'B.I/Cartão de Cidadão'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          return null;
                        },
                        controller: codigoPostalController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Color(0xfffafafa),
                            labelText: 'Código Postal'),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo obrigatório';
                          }

                          if (!isNumeric(value)) {
                            return 'Telefone Inválido';
                          }

                          return null;
                        },
                        controller: telefoneController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Color(0xfffafafa),
                            labelText: 'Telefone'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          return null;
                        },
                        controller: moradaController,
                        decoration: const InputDecoration(
                            border: InputBorder.none, filled: true, fillColor: Color(0xfffafafa), labelText: 'Morada'),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo obrigatório';
                          }

                          // Email format validation using a regular expression
                          bool isValidEmail =
                              RegExp(r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value);

                          if (!isValidEmail) {
                            return 'Email inválido';
                          }

                          return null;
                        },
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Color(0xfffafafa),
                          labelText: 'Email',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        child: TextFormField(
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime(1998),
                                //get today's date
                                firstDate: DateTime(1900),
                                //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime.now());
                            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate!);

                            setState(() {
                              dataNascimentoController.text = formattedDate;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo obrigatório';
                            }
                            return null;
                          },
                          controller: dataNascimentoController,
                          keyboardType: TextInputType.datetime,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Color(0xfffafafa),
                            labelText: 'Data de Nascimento',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      // Wrap the visibility widget with an Expanded widget
                      child: TextFormField(
                        controller: numClienteNOSController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Color(0xfffafafa),
                          labelText: 'Nº Cliente NOS(c243434)',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                const Row(
                  children: [
                    Text(
                      'Tamanho da T-shirt',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: ['S', 'M', 'L', 'XL'].map((size) {
                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTShirtSize = size;
                          });
                        },
                        child: Container(
                          width: 40.0,
                          height: 40.0,
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: size == selectedTShirtSize ? Colors.yellow : Colors.grey,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                              child: Text(
                            size,
                          )),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                BlocConsumer<TeamCubit, TeamState>(
                  listenWhen: (previous, current) =>
                      current is UpdateTeamMemberLoaded || current is UpdateTeamMemberError,
                  buildWhen: (previous, current) =>
                      current is UpdateTeamMemberLoading ||
                      current is UpdateTeamMemberLoaded ||
                      current is UpdateTeamMemberError,
                  listener: (context, state) {
                    if (state is UpdateTeamMemberLoaded || state is UpdateTeamMemberError) {
                      Navigator.pop(context);
                    }
                  },
                  builder: (context, state) {
                    if (state is UpdateTeamMemberLoading) {
                      return const CircularProgressIndicator();
                    }
                    return ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            updateUserDataFromControllers();
                            BlocProvider.of<TeamCubit>(context).updateTeamMember(widget.user);
                          }
                        },
                        child: const Text('Salvar Dados'));
                  },
                )
              ],
            ),
          ),
        ));
  }

  void updateUserDataFromControllers() {
    widget.user.name = nomeController.text;
    widget.user.cc = biController.text;
    widget.user.postalCode = codigoPostalController.text;
    widget.user.phone = telefoneController.text;
    widget.user.address = moradaController.text;
    widget.user.email = emailController.text;
    widget.user.dateOfBirth = DateTime.parse(dataNascimentoController.text);
    widget.user.nosCard = numClienteNOSController.text;
    widget.user.tShirtSize = selectedTShirtSize!;
  }

  bool areAllFieldsComplete() {
    return nomeController.text.isNotEmpty &&
        biController.text.isNotEmpty &&
        codigoPostalController.text.isNotEmpty &&
        telefoneController.text.isNotEmpty &&
        numClienteNOSController.text.isNotEmpty;
  }

  bool isNumeric(String value) {
    final numericRegex = RegExp(r'^-?[0-9]+$');
    return numericRegex.hasMatch(value);
  }

  @override
  void dispose() {
    nomeController.dispose();
    biController.dispose();
    codigoPostalController.dispose();
    telefoneController.dispose();
    numClienteNOSController.dispose();
    dataNascimentoController.dispose();
    moradaController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
