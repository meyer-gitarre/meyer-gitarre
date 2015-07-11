module.exports = (menuStructure) ->
  if menuStructure?
    ancestor = menuStructure[0]

  switch ancestor
    when 'Blockflöte' then return 'bflColor'
    when 'Gitarre' then return 'gitColor'
    when 'Musiklehre' then return 'musColor'
    else return 'defaultColor'
