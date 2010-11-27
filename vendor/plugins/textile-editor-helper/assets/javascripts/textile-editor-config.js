var teButtons = TextileEditor.buttons;

teButtons.push(new TextileEditorButton('ed_strong',			'bold.png',          '*',   '*',  'b', 'Жирный','s'));
teButtons.push(new TextileEditorButton('ed_emphasis',		'italic.png',        '_',   '_',  'i', 'Курсив','s'));
teButtons.push(new TextileEditorButton('ed_underline',	'underline.png',     '+',   '+',  'u', 'Подчеркнутый','s'));
teButtons.push(new TextileEditorButton('ed_strike',     'strikethrough.png', '-',   '-',  's', 'Зачеркнутый','s'));
teButtons.push(new TextileEditorButton('ed_ol',					'list_numbers.png',  ' # ', '\n', ',', 'Нумерованный список'));
teButtons.push(new TextileEditorButton('ed_ul',					'list_bullets.png',  ' * ', '\n', '.', 'Список кружочками'));
teButtons.push(new TextileEditorButton('ed_p',					'paragraph.png',     'p',   '\n', 'p', 'Параграф'));
teButtons.push(new TextileEditorButton('ed_h1',					'h1.png',            'h1',  '\n', '1', 'Заголовок 1'));
teButtons.push(new TextileEditorButton('ed_h2',					'h2.png',            'h2',  '\n', '2', 'Заголовок 2'));
teButtons.push(new TextileEditorButton('ed_h3',					'h3.png',            'h3',  '\n', '3', 'Заголовок 3'));
teButtons.push(new TextileEditorButton('ed_h4',					'h4.png',            'h4',  '\n', '4', 'Заголовок 4'));
teButtons.push(new TextileEditorButton('ed_block',   		'blockquote.png',    'bq',  '\n', 'q', 'Кавычки'));
teButtons.push(new TextileEditorButton('ed_outdent', 		'outdent.png',       ')',   '\n', ']', 'Отступ'));
teButtons.push(new TextileEditorButton('ed_indent',  		'indent.png',        '(',   '\n', '[', 'Выступ'));
teButtons.push(new TextileEditorButton('ed_justifyl',		'left.png',          '<',   '\n', 'l', 'Выравнивание слева'));
teButtons.push(new TextileEditorButton('ed_justifyc',		'center.png',        '=',   '\n', 'e', 'Текст по центру'));
teButtons.push(new TextileEditorButton('ed_justifyr',		'right.png',         '>',   '\n', 'r', 'Выравнивание справа'));
teButtons.push(new TextileEditorButton('ed_justify', 		'justify.png',       '<>',  '\n', 'j', 'По всей ширине'));

// teButtons.push(new TextileEditorButton('ed_code','code','@','@','c','Code'));