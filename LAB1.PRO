Domains
    question = string
    answer   = string
    index    = integer

Database
    testing(index, question, answer).

Predicates
    start
    load_db
    print_menu
    process_choice(integer)
    run_test
    count_questions(integer)
    count_up(integer, integer, integer)
    ask_all(index)
    check_answer(index, answer)
    add_new_data
    all_db

Clauses

    start :-
        makewindow(1,27,57,"Testing",0,0,25,80),
        print_menu,
        readint(Choice),
        process_choice(Choice).

    load_db :-
        existfile("test_base.dat"), !,
        consult("test_base.dat"),
        write("The database is loaded"), nl.
    load_db :-
        write("The file 'test_base.dat' was not found. A new database is being created."), nl.

    print_menu :- nl,
        write("=== Menu ==="), nl,
        write("1. Take the test"), nl,
        write("2. Add a question to the database"), nl,
        write("3. Exit"), nl,
        write("4. All"), nl,
        write("Select an item: ").

    process_choice(1) :- run_test, start.
    process_choice(2) :- add_new_data, start.
    process_choice(3) :- save("test_base.dat"), retractall(testing(_, _, _)), write("GoodBye!"), nl, !.
    process_choice(4) :- all_db, readchar(_), start.
    process_choice(_) :- write("Wrong Choice! Pick the right number"), readchar(_), nl, start.

    run_test :-
        count_questions(N),
        N > 0, !,
        ask_all(1).
    run_test :- write("The Database is empty"), readchar(_), nl.

    ask_all(I) :-
        count_questions(N),
        I <= N, !,
        testing(I, Q, _),
        write("Question number "), write(I), write(": "),
        write(Q), nl,
        write("Your answer: "),
        readln(UserAnswer),
        check_answer(I, UserAnswer),
        I1 = I + 1,
        ask_all(I1).
    ask_all(_).

    check_answer(I, UserAnswer) :- 
        testing(I, _, Correct),
        upper_lower(Correct,Correct1),
        upper_lower(UserAnswer,UserAnswer1),
        UserAnswer1 = Correct1, !,
        write("Correctly!"), readchar(_), nl, nl.

    check_answer(I, _) :-
        testing(I, _, Correct),
        write("Wrong. Right answer: "), write(Correct), readchar(_), nl, nl.

    add_new_data :-
        write("Ask a question: "),
        readln(Question),
        write("Enter the correct answer: "),
        readln(Answer),
        count_questions(N),
        N1 = N + 1,
        assertz(testing(N1, Question, Answer)),
        write("Question added."), readchar(_), nl.

    count_questions(N) :-
        count_up(1, 0, N).

    count_up(I, Acc, N) :-
        testing(I, _, _), !,
        Acc1 = Acc + 1,
        I1 = I + 1,
        count_up(I1, Acc1, N).
    count_up(_, Acc, Acc).

    all_db :-
        testing(I, Q, A),
        write("testing: "), write(I), write(", "), write(Q), write(", "), write(A), nl,fail.
    all_db :-
        write("End").
        

Goal
    load_db, start.