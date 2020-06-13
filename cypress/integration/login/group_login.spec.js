context('Group login', () => {
  const uuid = () => Cypress._.random(0, 1e6)
  const groupName = 'Sample name ' + uuid()

  before(() => {
    cy.visit('http://localhost:3000/users/sign_in')
    cy.login('admin@example.com', '12345678')
    cy.createGroup(groupName)
  })

  beforeEach(() => {
    cy.clearCookies()
  })

  it('use valid auth code', () => {
    cy.loginAsGroup(groupName)
    cy.get('.navbar').should('contain', groupName)
  })

  it('use invalid auth code', () => {
    cy.loginWithCode('123456')
    cy.get('.alert.alert-danger').should('contain', 'El código es incorrecto o ha expirado')
  })
})
