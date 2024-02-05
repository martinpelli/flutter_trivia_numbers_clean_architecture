import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/number_trivia_bloc.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Number Trivia')), body: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    return BlocProvider(
        create: (_) => serviceLocator<NumberTriviaBloc>(),
        child: const Center(
          child: Padding(padding: EdgeInsets.all(10), child: _TriviaControls()),
        ));
  }
}

class _TriviaControls extends StatefulWidget {
  const _TriviaControls();

  @override
  State<_TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<_TriviaControls> {
  String? inputStr;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<NumberTriviaBloc>(context);
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
              builder: (context, state) {
                if (state is Empty) {
                  return const MessageDisplay(text: 'Start searching!');
                } else if (state is Loading) {
                  return const LoadingWidget();
                } else if (state is Loaded) {
                  return TriviaDisplay(numberTrivia: state.trivia);
                } else {
                  final errorState = state as Error;
                  return MessageDisplay(text: errorState.message);
                }
              },
            )),
        TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "Input a number"),
            onChanged: (value) {
              inputStr = value;
            }),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(
              child: ElevatedButton(
                  onPressed: () {
                    if (inputStr == null) return;
                    controller.clear();
                    bloc.add(GetTriviaForConcreteNumber(numberString: inputStr!));
                  },
                  child: const Text("Search"))),
          const SizedBox(width: 10),
          Expanded(
              child: ElevatedButton(
                  onPressed: () {
                    controller.clear();
                    bloc.add(GetTriviaForRandomNumber());
                  },
                  child: const Text("Random")))
        ])
      ],
    );
  }
}
