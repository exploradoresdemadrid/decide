/// <reference types="cypress" />

context('Question creation', () => {
  const uuid = () => Cypress._.random(0, 1e6)
  const currentUUID = uuid()
  const votingTitle = 'Voting ' + currentUUID

  before(() => {
    cy.clearCookies()
    cy.loginAsAdmin()

    cy.createVoting(votingTitle, {})
    cy.visit('http://localhost:3000/')
  })
  beforeEach(() => {
    Cypress.Cookies.preserveOnce('_decide_session')
  })

  it('create questions in a voting', () => {
    cy.contains(votingTitle).click()
    cy.contains('Preguntas').click()
    cy.contains('Nueva pregunta').click()

    cy.contains('Title').click().type('Sample title')
    cy.contains('Añadir opción').click()
    cy.get('.options-form input.form-control').type('Option 1')
    cy.contains('Enviar').click()

    cy.get('#notice').should('contain', 'Question was successfully created.')
    cy.get('#questions_index').should('contain', 'Sample title')
    cy.get('#questions_index').should('contain', 'Option 1')
  })

  it('Add option to an existing question', () => {
    cy.get('#questions_index').contains('td', 'Sample title').parent().contains('Editar').click()
    cy.contains('Añadir opción').click()
    cy.get('.options-form input.form-control').last().type('Option 2')
    cy.contains('Enviar').click()

    cy.get('#notice').should('contain', 'Question was successfully updated.')
    cy.get('#questions_index').should('contain', 'Sample title')
    cy.get('#questions_index').should('contain', 'Option 1')
    cy.get('#questions_index').should('contain', 'Option 2')
  })

  it('Remove an option to an existing question', () => {
    cy.get('#questions_index').contains('td', 'Sample title').parent().contains('Editar').click()
    cy.get('.remove_fields').contains('Eliminar').click()
    cy.contains('Enviar').click()

    cy.get('#notice').should('contain', 'Question was successfully updated.')
    cy.get('#questions_index').should('contain', 'Sample title')
    cy.get('#questions_index').should('not.contain', 'Option 1')
    cy.get('#questions_index').should('contain', 'Option 2')
  })
})
