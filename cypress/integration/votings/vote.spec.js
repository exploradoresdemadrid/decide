/// <reference types="cypress" />

context('Vote submission', () => {
  before(() => {
    const uuid = () => Cypress._.random(0, 1e6)
    const currentUUID = uuid()
    const votingTitle = 'Voting ' + currentUUID
    const groupName = 'Group ' + currentUUID 

    cy.clearCookies()
    cy.visit('http://localhost:3000/users/sign_in')
    cy.login('admin@example.com', '12345678')
    cy.createVoting(votingTitle, { status: 'open' })
    cy.createQuestion(votingTitle, {})
    cy.createGroup(groupName)
    cy.loginAsGroup(groupName)
    cy.contains(votingTitle).click()
  })
  beforeEach(() => {
    Cypress.Cookies.preserveOnce('_decide_session')
  })

  it('empty vote submission', () => {
    cy.get('.total-votes-counter').should('contain', '0/5')
    cy.contains('Emitir votos').click()

    cy.get('.alert.alert-danger').should('contain', 'Debes emitir 5 votos en cada pregunta')
    
  })

  it('submit extra votes', () => {
    cy.get('input[type=range]').first().invoke('val', 3).trigger('change')
    cy.get('input[type=range]').last().invoke('val', 5).trigger('change')

    cy.get('.total-votes-counter').should('contain', '8/5')
    cy.get('body').contains('Emitir votos').click()

    cy.get('.alert.alert-danger').should('contain', 'Debes emitir 5 votos en cada pregunta')
  })

  it('submit less votes', () => {
    cy.get('input[type=range]').first().invoke('val', 1).trigger('change')
    cy.get('input[type=range]').last().invoke('val', 2).trigger('change')

    cy.get('.total-votes-counter').should('contain', '3/5')
    cy.get('body').contains('Emitir votos').click()

    cy.get('.alert.alert-danger').should('contain', 'Debes emitir 5 votos en cada pregunta')
  })

  it('submit available votes', () => {
    cy.get('input[type=range]').first().invoke('val', 3).trigger('change')
    cy.get('input[type=range]').last().invoke('val', 2).trigger('change')

    cy.get('.total-votes-counter').should('contain', '5/5')
    cy.get('body').contains('Emitir votos').click()

    cy.get('.alert.alert-danger').should('contain', 'Tu voto ha sido enviado. En cuanto finalice la votación podrás ver los resultados.')
  })
})
