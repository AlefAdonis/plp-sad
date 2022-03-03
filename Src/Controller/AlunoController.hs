module Src.Controller.AlunoController where
    import Src.Model.Aluno as A
    import Src.Util.TxtFunctions
    import Src.Controller.DisciplinaController as DC
    
    getAluno:: Int -> IO Aluno
    getAluno id = do
        alunoToString <- getObjetoById "Alunos" id
        return (read alunoToString :: Aluno)

    adicionaAluno :: IO()
    adicionaAluno = do
        putStrLn "Insira o nome do aluno: "
        nome <- getLine
        putStrLn "Insira a matricula do aluno"
        matricula <- readLn
        putStrLn "Insira as disciplinas do aluno"
        disciplinas <- readLn
        let aluno = Aluno matricula nome disciplinas
        adicionaLinha "Alunos" $ show aluno
        putStrLn "Aluno cadastrado com sucesso.\n"

    matriculaAlunoEmDisciplina :: Aluno -> IO()
    matriculaAlunoEmDisciplina aluno = do
        putStrLn "Você está matriculado nas seguintes disciplinas:"
        putStrLn (show (disciplinas aluno))
        putStrLn "Estas são todas as disciplinas disponíveis para matrícula:\n"
        exibeDisciplinasDisponiveis aluno
        putStrLn "\nInforme a sigla da disciplina na qual deseja se matricular:"
        sigla <- getLine
        siglasCadastradas <- getSiglas
        if sigla `elem` siglasCadastradas then
            if sigla `elem` disciplinas aluno then do
                putStrLn ("Você já está matriculado em " ++ sigla ++ ", tente novamente\n\n")
                matriculaAlunoEmDisciplina aluno
            else do
                let alunoAtualizado = Aluno (A.id aluno) (nome aluno) (sigla : disciplinas aluno)
                atualizaLinhaById "Alunos" (show (A.id aluno)) (show alunoAtualizado)
                putStrLn "Matricula realizada com sucesso!"
        else do
            putStrLn "Sigla Inválida , tente novamente\n\n"
            matriculaAlunoEmDisciplina aluno

    desmatriculaAlunoDeDisciplina :: Aluno -> IO()
    desmatriculaAlunoDeDisciplina aluno = do
        putStrLn "\nVocê está matriculado nas seguintes disciplinas:\n"
        print (show (disciplinas aluno))
        putStrLn "Informe a sigla da disciplina na qual deseja se desmatricular: "
        sigla <- getLine
        if sigla `elem` disciplinas aluno then do
            let disciplinasExcetoMencionada = filter (/= sigla) (disciplinas aluno)
            let alunoAtualizado = Aluno (A.id aluno) (nome aluno) disciplinasExcetoMencionada
            atualizaLinhaById "Alunos" (show (A.id aluno)) (show alunoAtualizado)
            putStrLn "Cancelamento de matricula realizada com sucesso!\n"
        else do
            putStrLn "Insira um valor válido!\n\n"
            desmatriculaAlunoDeDisciplina aluno

    --mostraTicketsResolvidos :: Aluno ->  IO()
    --mostraTicketsResolvidos aluno = do
    --    let disc = disciplinas aluno
    --    mostraTicketsDeDisciplinas disc

    --mostraTicketsDeDisciplinas :: [String] -> IO()
    --mostraTicketsDeDisciplinas [] = return ()
    --mostraTicketsDeDisciplinas (disciplina:resto) = do
    --    TicketsDisciplina disciplina
    --    mostraTicketsDeDisciplinas resto
