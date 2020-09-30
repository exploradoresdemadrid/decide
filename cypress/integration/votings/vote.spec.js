/// <reference types="cypress" />

context('Vote submission', () => {
  const uuid = () => Cypress._.random(0, 1e6)
  const currentUUID = uuid()
  const votingTitle = 'Voting ' + currentUUID
  const groupName = 'Group ' + currentUUID 

  before(() => {
    cy.clearCookies()
    cy.loginAsAdmin()
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

    cy.get('.alert.alert-danger').should('contain', 'Debes enviar 5 papeletas en cada pregunta')
    
  })

  it('submit extra votes', () => {
    cy.get('input[type=range]').first().invoke('val', 3).trigger('change')
    cy.get('input[type=range]').last().invoke('val', 5).trigger('change')

    cy.get('.total-votes-counter').should('contain', '8/5')
    cy.get('body').contains('Emitir votos').click()

    cy.get('.alert.alert-danger').should('contain', 'Debes enviar 5 papeletas en cada pregunta')
  })

  it('submit less votes', () => {
    cy.get('input[type=range]').first().invoke('val', 1).trigger('change')
    cy.get('input[type=range]').last().invoke('val', 2).trigger('change')

    cy.get('.total-votes-counter').should('contain', '3/5')
    cy.get('body').contains('Emitir votos').click()

    cy.get('.alert.alert-danger').should('contain', 'Debes enviar 5 papeletas en cada pregunta')
  })

  it('submit available votes', () => {
    cy.get('input[type=range]').first().invoke('val', 3).trigger('change')
    cy.get('input[type=range]').last().invoke('val', 2).trigger('change')

    cy.get('.total-votes-counter').should('contain', '5/5')
    cy.get('body').contains('Emitir votos').click()

    cy.get('.alert.alert-danger').should('contain', 'Tu papeleta ha sido enviada. En cuanto se cierre la urna virtual podrás ver los resultados.')
  })

  it('stay on the same page on reload', () => {
    cy.contains('Recargar').click()

    cy.get('.alert.alert-danger').should('contain', 'Tu papeleta ha sido enviada. En cuanto se cierre la urna virtual podrás ver los resultados.')
  })

  it('shows results once voting is finished', () => {
    cy.logout()
    cy.loginAsAdmin()

    cy.contains(votingTitle).click()
    cy.wait(2000)

    cy.contains('a', 'Editar').click()
    cy.get('#voting_status').select('finished')
    cy.contains('Enviar').click()

    cy.get('.panel-heading').first().should('contain', 'Resultados')
    cy.get('.panel-heading').last().should('contain', 'Diagrama de barras')
  })
})
