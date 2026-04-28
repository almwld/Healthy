import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/consultation/consultation_bloc.dart';
import '../../models/consultation_model.dart';
import '../../utils/constants.dart';

class ActiveConsultationScreen extends StatefulWidget {
  final String consultationId;
  const ActiveConsultationScreen({Key? key, required this.consultationId}) : super(key: key);
  @override
  State<ActiveConsultationScreen> createState() => _ActiveConsultationScreenState();
}

class _ActiveConsultationScreenState extends State<ActiveConsultationScreen> {
  final _msgCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ConsultationBloc>().add(LoadConsultationDetailEvent(widget.consultationId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الاستشارة النشطة'),
        actions: [
          IconButton(icon: const Icon(Icons.call_end, color: Colors.red), onPressed: () {
            context.read<ConsultationBloc>().add(EndConsultationEvent(widget.consultationId));
            Navigator.pop(context);
          }),
        ],
      ),
      body: BlocBuilder<ConsultationBloc, ConsultationState>(
        builder: (context, state) {
          if (state is ConsultationDetailLoaded) {
            return Column(children: [
              // Doctor info bar
              Container(padding: const EdgeInsets.all(12), color: AppColors.primary.withOpacity(0.1),
                child: Row(children: [
                  const CircleAvatar(backgroundColor: AppColors.primary, child: Icon(Icons.person, color: Colors.white)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(state.consultation.doctorName ?? 'الطبيب المعالج', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const Text('متصل', style: TextStyle(color: AppColors.success, fontSize: 12)),
                  ])),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
                    child: const Text('00:05:23', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ]),
              ),
              // Messages
              Expanded(child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.messages.length,
                itemBuilder: (context, i) {
                  final msg = state.messages[i];
                  final isMe = msg.senderType == 'patient';
                  return Align(
                    alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                      decoration: BoxDecoration(
                        color: isMe ? AppColors.primary : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(msg.content, style: TextStyle(color: isMe ? Colors.white : AppColors.textPrimary)),
                    ),
                  );
                },
              )),
              // Input
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppColors.divider))),
                child: Row(children: [
                  IconButton(icon: const Icon(Icons.attach_file), onPressed: () {}),
                  Expanded(child: TextField(controller: _msgCtrl, decoration: const InputDecoration(hintText: 'اكتب رسالتك...', border: InputBorder.none))),
                  IconButton(
                    icon: const Icon(Icons.send, color: AppColors.primary),
                    onPressed: () {
                      if (_msgCtrl.text.isNotEmpty) {
                        context.read<ConsultationBloc>().add(SendMessageEvent(widget.consultationId, _msgCtrl.text));
                        _msgCtrl.clear();
                      }
                    },
                  ),
                ]),
              ),
            ]);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
