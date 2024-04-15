INSERT INTO proposed_answers (answer, question_id)
VALUES
    ('prva smjena',  (select id from questions where name = 'Koje je radno vrijeme posla?')),
    ('druga smjena', (select id from questions where name = 'Koje je radno vrijeme posla?')),
    ('noćna smjena', (select id from questions where name = 'Koje je radno vrijeme posla?')),
    ('vikend',  (select id from questions where name = 'Koje je radno vrijeme posla?')),
    ('1h-2h',  (select id from questions where name = 'Koje je radno vrijeme posla?')),
    ('2h-3h',  (select id from questions where name = 'Koje je radno vrijeme posla?')),
    ('4h i više',  (select id from questions where name = 'Koje je radno vrijeme posla?')),
    ('po dogovoru',  (select id from questions where name = 'Koje je radno vrijeme posla?')),
    ('pon-pet',  (select id from questions where name = 'Koje je radno vrijeme posla?')),
    ('vikend',  (select id from questions where name = 'Koje je radno vrijeme posla?')),
    ('praznici', (select id from questions where name = 'Koje je radno vrijeme posla?')),
    ('dan smjena',  (select id from questions where name = 'Koje je radno vrijeme posla?')),

    ('po satu',  (select id from questions where name = 'Način plaćanja?')),
    ('dnevnica',  (select id from questions where name = 'Način plaćanja?')),
    ('po dogovoru',  (select id from questions where name = 'Način plaćanja?')),

    ('prekovremene sate', (select id from questions where name = 'Da li plaćate?')),
    ('topli obrok',  (select id from questions where name = 'Da li plaćate?'));
