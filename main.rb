require 'raabro'
# documentação: https://github.com/floraison/raabro

module ExpressaoReconhecedora include Raabro
  def num_neg(i); rex(:num_neg, i, /\-[0-9]+/); end
  def num(i); rex(:num, i, /[0-9]+/); end
  def mais(i); rex(:mais, i, /\+/); end
  def menos(i); rex(:menos, i, /\-/); end
  def multi(i); rex(:multi, i, /\*/); end
  def pstart(i); rex(:pstart, i, /\(/); end
  def pend(i); rex(:pend, i, /\)/); end
  def multi(i); rex(:multi, i, /\*/); end
  def pot(i); rex(:pot, i, /\^/); end
  def div(i); rex(:div, i, /\//); end
  
  
  def potencia_conjunta(i); seq(:potencia_conjunta, i, :num, :pot, :menos, :divisao); end
  def divisao_conjunta(i); seq(:divisao_conjunta, i, :multiplicacao, :div, :num); end
  def soma_conjunta3(i); seq(:soma_conjunta3, i, :divisao_conjunta, :mais, :num); end
 
  def exp(i); seq(:exp, i, :pstart, :adicao, :pend); end
  def exp2(i); seq(:exp2, i, :pstart, :subtracao, :pend); end
  def exp3(i); seq(:exp3, i, :soma); end
  
 
  def multiplicacao(i); seq(:multiplicacao, i, :num, :multi, :num); end
  def divisao(i); seq(:divisao, i, :num, :div, :num); end
  def adicao(i); seq(:adicao, i, :num, :mais, :num); end
  def subtracao(i); seq(:subtracao, i, :num, :menos, :num); end
  def potencia(i); seq(:potencia, i, :num, :pot, :num); end

  ##saidas
  def exp_final0(i); seq(:soma_conjunta, i, :num, :mais, :multiplicacao); end
  def exp_final1(i); seq(:exp2, i, :exp, :multi, :potencia); end
  def exp_final2(i); seq(:exp_final2, i, :num, :div, :exp2 ); end
  def exp_final3(i); seq(:exp_final3, i, :num, :mais, :potencia_conjunta); end
  def exp_final4(i); seq(:exp_final4, i, :num, :pot, :pstart,:soma_conjunta3, :pend); end  
  
  def expressao(i); alt(:expressao, i, :exp_final3, :exp_final4, :exp_final1, :exp_final0, :exp_final2); end

  
  def rewrite_expressao(t)
    teste = t.string

    ## EXPRESSAO 3

    if teste.include?"^" and teste.include?"*" and teste.include?"/" and teste.include?"+"
      parcial = teste.partition('/').first
      multiplicacao = parcial.delete('9').delete('^').delete('(').delete('*').insert 1, ","
      parcial2 = teste.partition('/').last
      parcial3 = parcial2.delete('+').delete(')')
      divisao = parcial3[0]
      adicao = parcial3[1]
      potencia = parcial[0]

      ["potencia", "[", "multiplicacao", multiplicacao, "[", "divisao", divisao, "[", "adicao", adicao,"]","]","]", potencia]

    ## EXPRESSAO 4
    elsif teste.include?"+" and teste.include?"^" and teste.include?"-" and teste.include?"/"
      parcial = teste.partition('^').last
      divisao = parcial.delete("-").delete("/").insert 1, ","
      parcial2 = teste.partition('-').first
      potencia = parcial2.delete("2").delete("+").delete("^")
      soma = teste.partition('+').first
      
      [ "soma", "[potencia", potencia, "[divisão", divisao,"]","]", soma]

    ## EXPRESSAO 1
    
    elsif teste.include?"+" and teste.include?"*" and teste.include?"^"
      parcial = teste.partition('*').last
      potencia = parcial.delete('^').insert 1, ","
      parcial2 = teste.partition(')').first
      soma = parcial2.delete('+').delete('(').insert 1, ","
      ['soma', soma,'multiplicação', 'potencia',potencia]

    ## EXPRESSAO 0
    
    elsif teste.include?"+" and teste.include?"*"
      parcial = teste.partition('+').last
      soma = teste.partition('+').first
      multiplicacao = parcial.delete('*').insert 1,","
      ['soma, [multiplicacao',multiplicacao,']',soma]


     ## EXPRESSAO 2
    
    elsif teste.include?"/" and teste.include?"-"
      parcial = teste.partition('/').last
      subtracao = parcial.delete('(').delete(')').delete('-').insert 1, ","
      divisao = teste.partition('/').first
      ['Divisão', '[Subtração', subtracao,']', divisao]

    end  
    
  end
end
  
module ExpressaoNumerica include Raabro
  def num_neg(i); rex(:num_neg, i, /\-[0-9]+/); end
  def num(i); rex(:num, i, /[0-9]+/); end
  def mais(i); rex(:mais, i, /\+/); end
  def menos(i); rex(:menos, i, /\-/); end
  def multi(i); rex(:multi, i, /\*/); end
  def pstart(i); rex(:pstart, i, /\(/); end
  def pend(i); rex(:pend, i, /\)/); end
  def multi(i); rex(:multi, i, /\*/); end
  def pot(i); rex(:pot, i, /\^/); end
  def div(i); rex(:div, i, /\//); end

  
  def soma(i); seq(:soma, i, :num, :mais, :num); end
  def soma_conjunta(i); seq(:soma_conjunta, i, :num, :mais, :multiplicacao); end
  def soma_conjunta_neg(i); seq(:soma_conjunta_neg, i, :multiplicacao_negativa, :mais, :num); end
  def subtracao(i); seq(:subtracao, i, :num, :menos, :num); end
  def potencia(i); seq(:potencia, i, :num, :pot, :num); end
  def potencia_conjunta(i); seq(:potencia_conjunta, i, :num, :pot, :expressao5); end
  def multiplicacao(i); seq(:multiplicacao, i, :num, :multi, :num); end
  def multiplicacao_negativa(i); seq(:multiplicacao_negativa, i, :num, :multi, :num_neg); end
  def divisao(i); seq(:divisao, i, :num, :div, :num); end
  def divisao_conjunta(i); seq(:divisao_conjunta, i, :num, :div, :args2); end
  def args(i); seq(:args, i, :pstart, :soma_conjunta_neg, :pend); end
  def args2(i); seq(:args2, i, :pstart, :soma, :pend); end
  
  def expressao5(i); alt(:expressao5, i, :args);end
  
  def expressao2(i); seq(:expressao2, i, :expressao5, :mais, :args2);end

  def expressao3(i); seq(:expressao3, i, :potencia_conjunta, :mais, :args2);end

  def expressao4(i); seq(:expressao4, i, :potencia_conjunta, :menos, :divisao_conjunta);end
  
  def expressao(i); alt(:expressao, i, :expressao4, :soma_conjunta, :soma, :subtracao, :multiplicacao, :divisao, :potencia, :num, :num_neg);end
  #def expressao(i); alt(:expressao, i, :expressao4);end

  # rewrites
  def rewrite_num_neg(t)
    "Reconhecido NUM_NEG: " + t.string
  end

  def rewrite_num(t)
    "Reconhecido NUM: " + t.string
  end

  def rewrite_mais(t)
    "Reconhecido MAIS"
  end

  def rewrite_multi(t)
    "Reconhecido MULT"
  end

  def rewrite_menos(t)
    "Reconhecido MENOS"
  end

  def rewrite_elevado(t)
    "Reconhecido ELEVADO"
  end
  
  def rewrite_pot(t)
    "Reconhecido POTENCIA"
  end

  def rewrite_div(t)
    "Reconhecido DIVISAO"
  end

  def rewrite_pstart(t)
    "Reconhecido PARENTESES"
  end

  def rewrite_pend(t)
    "Reconhecido PARENTESES"
  end
  
  def rewrite_soma_conjunta(t)
    folhas = t.children
    folhas.collect { |e| rewrite(e) }.append("Reconhecido SOMA_CONJUNTA")
  end
  def rewrite_soma_conjunta_neg(t)
    folhas = t.children
    folhas.collect { |e| rewrite(e) }.append("Reconhecido SOMA_CONJUNTA_NEGATIVA")
  end

  def rewrite_soma(t)
    folhas = t.children
    folhas.collect { |e| rewrite(e) }.append("Reconhecido SOMA")
  end

  def rewrite_subtracao(t)
    folhas = t.children
    folhas.collect { |e| rewrite(e) }.append("Reconhecido SUBTRACAO")
  end

  def rewrite_multiplicacao(t)
    folhas = t.children
    folhas.collect { |e| rewrite(e) }.append("Reconhecido MULTIPLICACAO")
  end
  def rewrite_multiplicacao_negativa(t)
    folhas = t.children
    folhas.collect { |e| rewrite(e) }.append("Reconhecido MULTIPLICACAO_NEGATIVA")
  end

  def rewrite_potencia_conjunta(t)
    folhas = t.children
    folhas.collect { |e| rewrite(e) }.append("Reconhecido POTENCIA_CONJUNTA")
  end

  def rewrite_potencia(t)
    folhas = t.children
    folhas.collect { |e| rewrite(e) }.append("Reconhecido POTENCIA")
  end
  
  def rewrite_divisao_conjunta(t)
    folhas = t.children
    folhas.collect { |e| rewrite(e) }.append("Reconhecido DIVISAO_CONJUNTA")
  end

  def rewrite_divisao(t)
    folhas = t.children
    folhas.collect { |e| rewrite(e) }.append("Reconhecido DIVISAO")
  end

  def rewrite_expressao(t)
    folhas = t.children
    folhas.collect { |e| rewrite(e) }.append("Reconhecido EXPRESSAO")
  end

  def rewrite_expressao2(t)
    folhas = t.children
    folhas.collect { |e| rewrite(e) }.append("Reconhecido EXPRESSAO2")
  end
  
  def rewrite_expressao3(t)
    folhas = t.children
    folhas.collect { |e| rewrite(e) }.append("Reconhecido EXPRESSAO3")
  end

  def rewrite_expressao4(t)
    folhas = t.children
    folhas.collect { |e| rewrite(e) }.append("Reconhecido EXPRESSAO4")
  end

  def rewrite_expressao5(t)
    folhas = t.children
    folhas.collect { |e| rewrite(e) }.append("Reconhecido EXPRESSAO5")
  end

  def rewrite_args(t)
    folhas = t.children
    folhas.collect { |e| rewrite(e) }.append("Reconhecido EXPRESSAO_PARCIAL")
  end

  def rewrite_args2(t)
    folhas = t.children
    folhas.collect { |e| rewrite(e) }.append("Reconhecido EXPRESSAO_PARCIAL2")
  end
end

## PARTE 1
p ExpressaoNumerica.parse("6")
p ExpressaoNumerica.parse("-6")
p ExpressaoNumerica.parse("6+4")
p ExpressaoNumerica.parse("6+1*2")
p ExpressaoNumerica.parse("6-4")
p ExpressaoNumerica.parse("6*2")
p ExpressaoNumerica.parse("6/2")
p ExpressaoNumerica.parse("6^2")
p ExpressaoNumerica.parse("9^(1*-2+3)-3/(6+3)")

## PARTE 2
p ExpressaoReconhecedora.parse('4+5*2')
p ExpressaoReconhecedora.parse('(1+4)*2^4')
p ExpressaoReconhecedora.parse('7/(1-3)')
p ExpressaoReconhecedora.parse('9^(1*6/2+4)')
p ExpressaoReconhecedora.parse('2+4^-4/4')