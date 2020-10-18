/// <reference types="cypress" />

context('Vote submission', () => {
  const uuid = () => Cypress._.random(0, 1e6)
  const currentUUID = uuid()
  const votingTitle = 'Voting ' + currentUUID
  const groupName = 'Group ' + currentUUID 

  before(() => {
    cy.clearCookies()
    cy.loginAsAdmin()
    cy.createVoting(votingTitle, { status: 'ready' })
    cy.createQuestion(votingTitle, {})
    cy.createGroup(groupName)
    cy.loginAsGroup(groupName)
    cy.contains(votingTitle).click()
  })
  beforeEach(() => {
    Cypress.Cookies.preserveOnce('_decide_session')
  })
  it('ready status', () => {
    cy.get('.alert.alert-warning').should('contain', 'You cannot vote yet. You must wait for the question to be opened.')
    cy.get('.question').should('contain', 'Sample title')
    cy.contains('Emitir votos').should('be.disabled')
  })

  it('empty vote submission', () => {
    cy.logout()
    cy.loginAsAdmin()
    cy.updateVotingStatus(votingTitle, 'open')

    cy.contains('Groups').click()
    cy.loginAsGroup(groupName)
    cy.contains(votingTitle).click()

    cy.get('.total-votes-counter').should('contain', '0/5')
    cy.contains('Emitir votos').click()
    cy.get('.alert.alert-danger').should('contain', 'You must submit 5 votes in each question')
  })

  it('submit extra votes', () => {
    cy.get('input[type=range]').first().invoke('val', 3).trigger('change')
    cy.get('input[type=range]').last().invoke('val', 5).trigger('change')

    cy.get('.total-votes-counter').should('contain', '8/5')
    cy.get('body').contains('Emitir votos').click()

    cy.get('.alert.alert-danger').should('contain', 'You must submit 5 votes in each question')
  })

  it('submit less votes', () => {
    cy.get('input[type=range]').first().invoke('val', 1).trigger('change')
    cy.get('input[type=range]').last().invoke('val', 2).trigger('change')

    cy.get('.total-votes-counter').should('contain', '3/5')
    cy.get('body').contains('Emitir votos').click()

    cy.get('.alert.alert-danger').should('contain', 'You must submit 5 votes in each question')
  })

  it('displays countdown timer before voting', () => {
    cy.get('body').should('contain', 'Tiempo de votación')
  })

  it('submit available votes', () => {
    cy.get('input[type=range]').first().invoke('val', 3).trigger('change')
    cy.get('input[type=range]').last().invoke('val', 2).trigger('change')

    cy.get('.total-votes-counter').should('contain', '5/5')
    cy.get('body').contains('Emitir votos').click()

    cy.get('.alert.alert-success').should('contain', 'Your vote was submitted. You will be able to see the results as soon as the voting finishes.')
  })

  it('displays countdown timer after voting', () => {
    cy.get('body').should('contain', 'Tiempo de votación')
  })

  it('shows results once voting is finished', () => {
    cy.logout()
    cy.loginAsAdmin()

    cy.updateVotingStatus(votingTitle, 'finished')

    cy.get('.panel-heading').first().should('contain', 'Results')
    cy.get('.panel-heading').last().should('contain', 'Bar chart')
  })

  it('shows results once voting is archived', () => {
    cy.updateVotingStatus(votingTitle, 'archived')

    cy.get('.panel-heading').first().should('contain', 'Results')
    cy.get('.panel-heading').last().should('contain', 'Bar chart')
  })
})
